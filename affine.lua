function jitter(s)
  if noaug then 
   dest = image.scale(s,sampleSize[2],sampleSize[3])
   dest = dest:resize(1,sampleSize[1],sampleSize[2],sampleSize[3])
  else 
    local d = torch.rand(2)
   -- vflip
    if d[1] > 0.5 then
      s = image.vflip(s)
    end
   -- hflip
    if d[2] > 0.5 then
      s = image.hflip(s)
    end
  
  local T1 = torch.eye(3,3)
  T1[1][3] = -loadSize[2]/2
  T1[2][3] = -loadSize[3]/2
  T1[3][3] = 1

  local S = torch.eye(3,3)
  S[1][2] = torch.rand(1):div(8)
  S[2][1] = torch.rand(1):div(8)

  local ang = torch.rand(1):mul(math.pi)
  local R = torch.Tensor(3,3):fill(0)
  R[1][1] = torch.cos(ang)
  R[2][1] = torch.sin(ang)
  R[1][2] = torch.sin(ang):mul(-1)
  R[2][2] = torch.cos(ang)
  R[3][3] = 1

  local T2 = torch.eye(3,3)
  T2[1][3] = torch.randn(1):mul(5):add(loadSize[2]/2)
  T2[2][3] = torch.randn(1):mul(5):add(loadSize[2]/2)
  T2[3][3] = 1

  local Sc = torch.eye(3,3):mul(torch.randn(1):div(10):add(1)[1])  --been using this
  local Sc = torch.eye(3,3)
  local Asp = torch.eye(3,3)
  local a = torch.rand(1):div(8):add(0.9375)
  Asp[1][1] = a[1]
  Asp[2][2] = 1/a[1]

  local T = torch.mm(S, T1)
  T = torch.mm(Sc, T)
  T = torch.mm(Asp,T)
  T = torch.mm(R,T)
  T = torch.mm(T2, T)
  T = T[{{1,2}, {1,3}}]

  dest = torch.Tensor(loadSize[2],loadSize[3]):fill(0)
  dest = opencv.WarpAffine(s,T)
  dest = image.scale(dest,sampleSize[2],sampleSize[3])
  dest = dest:resize(1,sampleSize[1],sampleSize[2],sampleSize[3])
end
return dest
end
