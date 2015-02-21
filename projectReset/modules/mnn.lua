require 'cunn'
require 'nn'
--torch.manualSeed(121)

-- featuresIn -> # of featuresIn
-- featuresOut -> # of featuresOut
-- nMaxOut of hidden MaxOut Units

function mnn(featuresIn, featuresOut, nMaxOut)
	local maxOutLay = nn.Sequential()
	local maxOut = nn.DepthConcat(2)
	for i = 1,nMaxOut do
		local lin = nn.Linear(featuresIn,featuresOut)
		maxOut:add(lin)
	end
	maxOutLay:add(maxOut)
	maxOutLay:add(nn.Reshape(nMaxOut,featuresOut))
	maxOutLay:add(nn.Transpose({2,3}))
	maxOutLay:add(nn.Max(nMaxOut))
	return maxOutLay
end

-- mdl = nn.Sequential()
-- mdl:add(mnn(10,10,3))
-- mdl:add(mnn(10,5,3))
-- mdl:cuda()
-- x = mdl:forward(torch.randn(2,10):cuda())
-- print(x)