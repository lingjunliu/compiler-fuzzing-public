#include <assert.h>
#include <omp.h>
#include <stdio.h>

// Tool related code below
#include <omp-tools.h>

// From openmp/runtime/test/ompt/callback.h
#define register_ompt_callback_t(name, type)                                   \
  do {                                                                         \
    type f_##name = &on_##name;                                                \
    if (ompt_set_callback(name, (ompt_callback_t)f_##name) == ompt_set_never)  \
      printf("0: Could not register callback '" #name "'\n");                  \
  } while (0)

#define register_ompt_callback(name) register_ompt_callback_t(name, name##_t)

ompt_id_t next_op_id = 0x8000000000000001;

// OMPT entry point handles
static ompt_set_callback_t ompt_set_callback = 0;

// OMPT callbacks

// Synchronous callbacks
static void on_ompt_callback_device_initialize(int device_num, const char *type,
                                               ompt_device_t *device,
                                               ompt_function_lookup_t lookup,
                                               const char *documentation) {
  printf("Callback Init: device_num=%d type=%s device=%p lookup=%p doc=%p\n",
         device_num, type, device, lookup, documentation);
}

static void on_ompt_callback_device_finalize(int device_num) {
  printf("Callback Fini: device_num=%d\n", device_num);
}

static void on_ompt_callback_device_load(int device_num, const char *filename,
                                         int64_t offset_in_file,
                                         void *vma_in_file, size_t bytes,
                                         void *host_addr, void *device_addr,
                                         uint64_t module_id) {
  printf("Callback Load: device_num:%d filename:%s host_adddr:%p "
         "device_addr:%p bytes:%lu\n",
         device_num, filename, host_addr, device_addr, bytes);
}

static void on_ompt_callback_target_data_op_emi(
    ompt_scope_endpoint_t endpoint, ompt_data_t *target_task_data,
    ompt_data_t *target_data, ompt_id_t *host_op_id,
    ompt_target_data_op_t optype, void *src_addr, int src_device_num,
    void *dest_addr, int dest_device_num, size_t bytes,
    const void *codeptr_ra) {
  assert(codeptr_ra != 0);
  // Both src and dest must not be null
  if (endpoint == ompt_scope_begin)
    *host_op_id = next_op_id++;
  printf("  Callback DataOp EMI: endpoint=%d optype=%d target_task_data=%p "
         "(0x%lx) target_data=%p (0x%lx) host_op_id=%p (0x%lx) src=%p "
         "src_device_num=%d "
         "dest=%p dest_device_num=%d bytes=%lu code=%p\n",
         endpoint, optype, target_task_data,
         target_task_data ? target_task_data->value : 0, target_data,
         target_data ? target_data->value : 0, host_op_id, *host_op_id,
         src_addr, src_device_num, dest_addr, dest_device_num, bytes,
         codeptr_ra);
}

static void on_ompt_callback_target_emi(ompt_target_t kind,
                                        ompt_scope_endpoint_t endpoint,
                                        int device_num, ompt_data_t *task_data,
                                        ompt_data_t *target_task_data,
                                        ompt_data_t *target_data,
                                        const void *codeptr_ra) {
  assert(codeptr_ra != 0);
  if (endpoint == ompt_scope_begin)
    target_data->value = next_op_id++;
  printf("Callback Target EMI: kind=%d endpoint=%d device_num=%d task_data=%p "
         "(0x%lx) target_task_data=%p (0x%lx) target_data=%p (0x%lx) code=%p\n",
         kind, endpoint, device_num, task_data, task_data->value,
         target_task_data, target_task_data->value, target_data,
         target_data->value, codeptr_ra);
}

static void on_ompt_callback_target_submit_emi(
    ompt_scope_endpoint_t endpoint, ompt_data_t *target_data,
    ompt_id_t *host_op_id, unsigned int requested_num_teams) {
  printf("  Callback Submit EMI: endpoint=%d  req_num_teams=%d target_data=%p "
         "(0x%lx) host_op_id=%p (0x%lx)\n",
         endpoint, requested_num_teams, target_data, target_data->value,
         host_op_id, *host_op_id);
}

// Init functions
int ompt_initialize(ompt_function_lookup_t lookup, int initial_device_num,
                    ompt_data_t *tool_data) {
  ompt_set_callback = (ompt_set_callback_t)lookup("ompt_set_callback");

  if (!ompt_set_callback)
    return 0; // failed

  register_ompt_callback(ompt_callback_device_initialize);
  register_ompt_callback(ompt_callback_device_finalize);
  register_ompt_callback(ompt_callback_device_load);
  register_ompt_callback(ompt_callback_target_data_op_emi);
  register_ompt_callback(ompt_callback_target_emi);
  register_ompt_callback(ompt_callback_target_submit_emi);

  return 1; // success
}

void ompt_finalize(ompt_data_t *tool_data) {}

#ifdef __cplusplus
extern "C" {
#endif
ompt_start_tool_result_t *ompt_start_tool(unsigned int omp_version,
                                          const char *runtime_version) {
  static ompt_start_tool_result_t ompt_start_tool_result = {&ompt_initialize,
                                                            &ompt_finalize, 0};
  return &ompt_start_tool_result;
}
#ifdef __cplusplus
}
#endif

/* Main program */
int main(void) {
  int *dev_ptr = omp_target_alloc(sizeof(int), 0);
#pragma omp target
  { printf("dev_ptr on device 0 = %p\n", dev_ptr); }
  omp_target_free(dev_ptr, 0);

  int host_arr[1];
  printf("host_arr on host = %p\n", host_arr);
#pragma omp target enter data map(to : host_arr[:1])
#pragma omp target
  { printf("host_arr on device 0 = %p\n", host_arr); }
#pragma omp target exit data map(from : host_arr[:1])
  return 0;
}