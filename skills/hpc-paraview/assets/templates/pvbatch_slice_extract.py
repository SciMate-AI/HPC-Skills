from paraview.simple import *

reader = OpenDataFile("input.vtu")
slice_filter = Slice(Input=reader)
slice_filter.SliceType.Origin = [0.0, 0.0, 0.0]
slice_filter.SliceType.Normal = [1.0, 0.0, 0.0]

writer = CreateWriter("slice_output.csv", slice_filter)
writer.UpdatePipeline()
