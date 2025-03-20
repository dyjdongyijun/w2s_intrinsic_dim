import os
import glob
from PIL import Image
import torch
from torch.utils.data import Dataset, DataLoader
from sklearn.model_selection import train_test_split
import torchvision.transforms as T

transform = T.Compose([
    T.Resize((224, 224)),           # 128 or 224, etc.
    T.ToTensor(),                   # Convert to a torch.Tensor
    # T.Normalize(mean=[0.5, 0.5, 0.5],
                # std=[0.5, 0.5, 0.5]) # Example normalization
])

class UTKFaceDataset(Dataset):
    """
    UTKFace images are typically named in the format:
      [age]_[gender]_[race]_[date].jpg
    This dataset parses the 'age' from the filename and
    returns (image, age) for each sample.
    """
    def __init__(self, root_dir, transform=transform):
        """
        Args:
            root_dir (str): Path to UTKFace directory containing .jpg files.
            transform (callable, optional): Optional transform to be applied
                on the PIL image.
        """
        self.root_dir = root_dir
        self.transform = transform
        # Collect all .jpg images in the directory
        self.image_paths = glob.glob(os.path.join(root_dir, "*.jpg"))
        
    def __len__(self):
        return len(self.image_paths)
    
    def __getitem__(self, idx):
        img_path = self.image_paths[idx]
        # Parse the filename to extract age
        filename = os.path.basename(img_path)  # e.g. "25_1_2_201701091505.jpg"
        parts = filename.split('_')
        
        # The first part is the age
        # (Sanity check: if there's any irregular naming, handle or skip)
        age = int(parts[0])  # Convert to integer
        
        # Load the image
        image = Image.open(img_path).convert('RGB')
        
        # Apply transforms if provided
        if self.transform:
            image = self.transform(image)
        
        # Return (image_tensor, float_age)
        return image, float(age)


def get_utkface_train_test_loader(dataset, batch_size=32, test_size=0.2, seed=42):
    """
    Helper function to return train and test data loaders.
    """
    # dataset = UTKFaceDataset(root_dir)
    train_idx, test_idx = train_test_split(
        list(range(len(dataset))), test_size=test_size, random_state=seed)
    
    train_sampler = torch.utils.data.SubsetRandomSampler(train_idx)
    test_sampler = torch.utils.data.SubsetRandomSampler(test_idx)
    
    train_loader = DataLoader(dataset, batch_size=batch_size, sampler=train_sampler)
    test_loader = DataLoader(dataset, batch_size=batch_size, sampler=test_sampler)
    
    return train_loader, test_loader