#include <cstdio>
#include <cuda_runtime.h>

__global__ void vector_add(const float *a, const float *b, float *c, int n)
{
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) c[i] = a[i] + b[i];
}

int main()
{
  const int n = 1024;
  const size_t bytes = n * sizeof(float);
  float *h_a = new float[n];
  float *h_b = new float[n];
  float *h_c = new float[n];

  for (int i = 0; i < n; ++i) {
    h_a[i] = 1.0f;
    h_b[i] = 2.0f;
  }

  float *d_a = nullptr;
  float *d_b = nullptr;
  float *d_c = nullptr;
  cudaMalloc(&d_a, bytes);
  cudaMalloc(&d_b, bytes);
  cudaMalloc(&d_c, bytes);

  cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice);

  const int block_size = 256;
  const int grid_size = (n + block_size - 1) / block_size;
  vector_add<<<grid_size, block_size>>>(d_a, d_b, d_c, n);
  cudaDeviceSynchronize();

  cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost);
  std::printf("c[0]=%.1f c[%d]=%.1f\n", h_c[0], n - 1, h_c[n - 1]);

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);
  delete[] h_a;
  delete[] h_b;
  delete[] h_c;
  return 0;
}
