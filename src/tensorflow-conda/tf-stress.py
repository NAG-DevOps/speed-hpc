import tensorflow as tf
import numpy as np
import time
import os
from datetime import datetime

# Set memory optimization environment variables
os.environ['TF_GPU_ALLOCATOR'] = 'cuda_malloc_async'
os.environ['TF_ENABLE_GPU_GARBAGE_COLLECTION'] = 'true'

def configure_gpu_memory():
    """Configure GPU memory settings for stability"""
    gpus = tf.config.experimental.list_physical_devices('GPU')
    if gpus:
        try:
            # Enable memory growth
            for gpu in gpus:
                tf.config.experimental.set_memory_growth(gpu, True)

            # Optional: Set memory limit (uncomment and adjust as needed)
            # tf.config.experimental.set_memory_limit(gpus[0], 4096)  # 4GB limit

            print(f"Found {len(gpus)} GPU(s)")

            # Get GPU details
            for i, gpu in enumerate(gpus):
                details = tf.config.experimental.get_device_details(gpu)
                print(f"GPU {i}: {details.get('device_name', 'Unknown')}")

            return True
        except RuntimeError as e:
            print(f"GPU configuration error: {e}")
            return False
    else:
        print("No GPUs found - using CPU")
        return False

def matrix_multiplication_safe():
    """Memory-safe matrix multiplication benchmark"""
    print("\n" + "="*50)
    print("MEMORY-SAFE MATRIX MULTIPLICATION")
    print("="*50)

    # Reduced sizes to avoid OOM
    sizes = [500, 1000, 1500, 2000]  # Much smaller than original
    results = {"CPU": [], "GPU": []}

    for size in sizes:
        print(f"\nTesting {size}x{size} matrix multiplication...")

        # Create matrices with explicit memory cleanup
        try:
            a = tf.random.normal([size, size], dtype=tf.float32)
            b = tf.random.normal([size, size], dtype=tf.float32)

            # CPU benchmark
            with tf.device('/CPU:0'):
                start_time = time.time()
                c_cpu = tf.matmul(a, b)
                cpu_time = time.time() - start_time
                results["CPU"].append(cpu_time)
                print(f"  CPU time: {cpu_time:.3f}s")

            # GPU benchmark (if available)
            if tf.config.list_physical_devices('GPU'):
                with tf.device('/GPU:0'):
                    start_time = time.time()
                    c_gpu = tf.matmul(a, b)
                    gpu_time = time.time() - start_time
                    results["GPU"].append(gpu_time)
                    print(f"  GPU time: {gpu_time:.3f}s")
                    print(f"  Speedup: {cpu_time/gpu_time:.2f}x")

            # Explicit cleanup
            del a, b, c_cpu
            if 'c_gpu' in locals():
                del c_gpu

        except tf.errors.ResourceExhaustedError as e:
            print(f"  OOM at size {size}: reducing further...")
            break
        except Exception as e:
            print(f"  Error at size {size}: {e}")

    return sizes[:len(results["CPU"])], results

def lightweight_cnn_training():
    """Memory-efficient CNN training"""
    print("\n" + "="*50)
    print("LIGHTWEIGHT CNN TRAINING")
    print("="*50)

    # Much smaller parameters to avoid OOM
    batch_size = 32  # Reduced from 128
    img_height, img_width = 64, 64  # Reduced from 224x224
    num_classes = 10  # Reduced from 1000
    num_samples = 1000  # Reduced from 10000

    print(f"Dataset: {num_samples} samples of {img_height}x{img_width}x3")
    print(f"Classes: {num_classes}, Batch size: {batch_size}")

    # Generate smaller synthetic dataset
    x_train = tf.random.normal([num_samples, img_height, img_width, 3])
    y_train = tf.random.uniform([num_samples], maxval=num_classes, dtype=tf.int32)
    y_train = tf.keras.utils.to_categorical(y_train, num_classes)

    # Create dataset with prefetch for efficiency
    dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train))
    dataset = dataset.batch(batch_size).prefetch(tf.data.AUTOTUNE)

    # Smaller, more memory-efficient model
    def create_efficient_cnn():
        model = tf.keras.Sequential([
            tf.keras.layers.Conv2D(32, 3, padding='same', activation='relu'),
            tf.keras.layers.MaxPooling2D(2),

            tf.keras.layers.Conv2D(64, 3, padding='same', activation='relu'),
            tf.keras.layers.MaxPooling2D(2),

            tf.keras.layers.Conv2D(128, 3, padding='same', activation='relu'),
            tf.keras.layers.MaxPooling2D(2),

            tf.keras.layers.GlobalAveragePooling2D(),
            tf.keras.layers.Dense(128, activation='relu'),
            tf.keras.layers.Dropout(0.5),
            tf.keras.layers.Dense(num_classes, activation='softmax')
        ])
        return model

    model = create_efficient_cnn()

    # Build the model first
    model.build(input_shape=(None, img_height, img_width, 3))

    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
        loss='categorical_crossentropy',
        metrics=['accuracy']
    )

    print(f"Model parameters: {model.count_params():,}")

    # Training with memory management
    epochs = 2  # Reduced epochs
    print(f"Training for {epochs} epochs...")

    try:
        start_time = time.time()
        history = model.fit(
            dataset,
            epochs=epochs,
            verbose=1,
            # Add callbacks for memory management
            callbacks=[
                tf.keras.callbacks.ReduceLROnPlateau(monitor='loss', patience=1),
            ]
        )

        total_time = time.time() - start_time
        print(f"\nTraining completed in {total_time:.2f}s")
        return total_time

    except tf.errors.ResourceExhaustedError as e:
        print(f"OOM during training: {e}")
        print("Try reducing batch_size or image dimensions further")
        return None

def memory_efficient_transformer():
    """Smaller transformer to avoid OOM"""
    print("\n" + "="*50)
    print("MEMORY-EFFICIENT TRANSFORMER")
    print("="*50)

    # Much smaller parameters
    vocab_size = 1000  # Reduced from 32000
    sequence_length = 128  # Reduced from 512
    d_model = 128  # Reduced from 512
    num_heads = 4  # Reduced from 8
    num_layers = 2  # Reduced from 6
    batch_size = 16  # Reduced from 32
    num_samples = 500  # Reduced from 5000

    print(f"Vocab: {vocab_size}, Seq len: {sequence_length}, Model dim: {d_model}")
    print(f"Heads: {num_heads}, Layers: {num_layers}, Batch size: {batch_size}")

    # Create smaller dataset
    x_data = tf.random.uniform([num_samples, sequence_length], maxval=vocab_size, dtype=tf.int32)
    y_data = tf.random.uniform([num_samples, sequence_length], maxval=vocab_size, dtype=tf.int32)

    dataset = tf.data.Dataset.from_tensor_slices((x_data, y_data))
    dataset = dataset.batch(batch_size).prefetch(tf.data.AUTOTUNE)

    # Simple transformer model
    def create_small_transformer():
        inputs = tf.keras.layers.Input(shape=(sequence_length,))

        # Embedding
        x = tf.keras.layers.Embedding(vocab_size, d_model)(inputs)
        x = tf.keras.layers.Dropout(0.1)(x)

        # Simple attention layers
        for _ in range(num_layers):
            # Multi-head attention
            attn_output = tf.keras.layers.MultiHeadAttention(
                num_heads=num_heads,
                key_dim=d_model // num_heads
            )(x, x)
            x = tf.keras.layers.Add()([x, attn_output])
            x = tf.keras.layers.LayerNormalization()(x)

            # Feed forward
            ffn = tf.keras.Sequential([
                tf.keras.layers.Dense(d_model * 2, activation='relu'),
                tf.keras.layers.Dense(d_model)
            ])
            ffn_output = ffn(x)
            x = tf.keras.layers.Add()([x, ffn_output])
            x = tf.keras.layers.LayerNormalization()(x)

        # Output
        outputs = tf.keras.layers.Dense(vocab_size)(x)

        model = tf.keras.Model(inputs=inputs, outputs=outputs)
        return model

    try:
        model = create_small_transformer()

        # Build the model first
        model.build(input_shape=(None, sequence_length))

        model.compile(
            optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001),
            loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
            metrics=['accuracy']
        )

        print(f"Transformer parameters: {model.count_params():,}")

        # Training with memory monitoring
        print("Training small transformer...")
        start_time = time.time()

        history = model.fit(
            dataset,
            epochs=1,  # Just 1 epoch to test
            verbose=1
        )

        training_time = time.time() - start_time
        print(f"Transformer training completed in {training_time:.2f}s")
        return training_time

    except tf.errors.ResourceExhaustedError as e:
        print(f"OOM in transformer: {e}")
        print("Transformer too large for available memory")
        return None

def adaptive_memory_test():
    """Test GPU memory limits adaptively"""
    print("\n" + "="*50)
    print("ADAPTIVE MEMORY TEST")
    print("="*50)

    if not tf.config.list_physical_devices('GPU'):
        print("No GPU available for memory test")
        return

    # Start with small size and increase gradually
    base_size = 100
    max_size = None

    print("Finding maximum workable tensor size...")

    for multiplier in [1, 2, 3, 5, 7, 10, 15, 20, 30, 40, 50]:
        size = base_size * multiplier
        memory_mb = size * size * 4 / 1024 / 1024

        try:
            print(f"\nTrying {size}x{size} matrix ({memory_mb:.1f} MB)...")

            with tf.device('/GPU:0'):
                # Try allocation
                a = tf.random.normal([size, size], dtype=tf.float32)
                b = tf.random.normal([size, size], dtype=tf.float32)

                # Computation to ensure memory is used
                start_time = time.time()
                c = tf.matmul(a, b)
                compute_time = time.time() - start_time

                # Get result to ensure computation completed
                result_sum = tf.reduce_sum(c).numpy()

                print(f"  ✓ Success! Compute time: {compute_time:.3f}s")
                print(f"  Result sum: {result_sum:.2e}")

                max_size = size

                # Cleanup
                del a, b, c

        except tf.errors.ResourceExhaustedError:
            print(f"  ✗ OOM at {size}x{size}")
            break
        except Exception as e:
            print(f"  ✗ Error: {str(e)[:50]}...")
            break

    if max_size:
        max_memory_mb = max_size * max_size * 4 / 1024 / 1024
        print(f"\nMaximum workable size: {max_size}x{max_size} ({max_memory_mb:.1f} MB)")
    else:
        print("\nCould not determine maximum size")

def run_memory_safe_benchmarks():
    """Run memory-safe versions of all benchmarks"""
    print("Memory-Safe TensorFlow GPU Benchmarks")
    print(f"Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"TensorFlow version: {tf.__version__}")

    # Configure GPU with memory safety
    gpu_available = configure_gpu_memory()

    # Run safe benchmarks
    try:
        # 1. Safe matrix multiplication
        sizes, results = matrix_multiplication_safe()

        # 2. Lightweight CNN
        cnn_time = lightweight_cnn_training()

        # 3. Small transformer (optional)
        transformer_time = memory_efficient_transformer()

        # 4. Adaptive memory test
        adaptive_memory_test()

        # Summary
        print("\n" + "="*50)
        print("BENCHMARK SUMMARY")
        print("="*50)
        if cnn_time:
            print(f"CNN training time: {cnn_time:.2f}s")
        if transformer_time:
            print(f"Transformer training time: {transformer_time:.2f}s")

        if gpu_available and results["GPU"]:
            completed_speedups = [cpu/gpu for cpu, gpu in zip(results["CPU"], results["GPU"]) if gpu > 0]
            if completed_speedups:
                avg_speedup = np.mean(completed_speedups)
                print(f"Average GPU speedup: {avg_speedup:.2f}x")

        print(f"Largest matrix tested: {max(sizes) if sizes else 'None'}x{max(sizes) if sizes else 'None'}")

    except KeyboardInterrupt:
        print("\nBenchmark interrupted by user")
    except Exception as e:
        print(f"\nBenchmark error: {e}")

if __name__ == "__main__":
    run_memory_safe_benchmarks()