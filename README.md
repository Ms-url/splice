# splice
## 图像拼接算法
完整操作参照standard_7，standard_7 是为7图拼接而编写,使用线性融合  
standard_sift中包含缝合线算法  
- slic 为超像素分割算法，matlab 中内置该算法  
- dhash 为哈希搜索算法，未使用

## 特征点检测算法
该部分包含3个算法实现
- sift
- orb
- fast
- siftDemoV4  sift原作者提供

## 缝合线算法
- maxFlow 
- minCut 
- getDiagram 
- gaborfilter 
- inosculate_get_E / inosculate_E
- inosculate_E_cut
- inosculate_weighted
- inosculate_sutureLine

## 图像融合
图像融合使用线性融合，单应性变换后，使用双线性插值
- splitJoint 
- homography 
- ransac_homoraphy 

## 完整拼接操作
standard_7 是为7图拼接而编写，完整拼接参照
- z_splice
- z_splice 中主要为线性融合

## other
standard_sift 较为臃肿，是为实验缝合线算法而写，同时包含了3次投影  
slic 中是编写实现SLIC，但效果不好，因此缝合线算法中使用内置函数实现超像素分割
