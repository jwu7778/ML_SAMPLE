import os

class DatasetCatalog(object):
    DATA_DIR = 'datasets'
    DATASETS = {
        'coco_2017_train': {
            'img_dir': 'GC10-Det/train/img', # image directory
            'ann_file': 'GC10-Det/train/ann/annotations.json' # annotation json directory
        },
        'coco_2017_val': {
            'img_dir': 'GC10-Det/valid/img', # image directory
            'ann_file': 'GC10-Det/valid/ann/annotations.json' # annotation json directory
        },
        }

    @staticmethod
    def get(name):
        if 'coco' in name:
            data_dir = DatasetCatalog.DATA_DIR
            attrs = DatasetCatalog.DATASETS[name]
            args = dict(
                root=os.path.join(data_dir, attrs['img_dir']),
                ann_file=os.path.join(data_dir, attrs['ann_file']),
            )
            return dict(
                factory='COCODataset',
                args=args,
            )
        else:
            raise RuntimeError('Only support coco format now!')
        return None