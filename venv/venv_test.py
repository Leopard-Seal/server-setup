import sys
import torch

def main():
    print(f"Python version: {sys.version}")
    print(f"PyTorch version: {torch.__version__}")
    print(f"CUDA available: {torch.cuda.is_available()}")
    if torch.cuda.is_available():
        print(f"CUDA version: {torch.version.cuda}")
    
    # Simple PyTorch operation to ensure it's working
    x = torch.rand(5, 3)
    print("Random tensor:")
    print(x)

if __name__ == "__main__":
    main()