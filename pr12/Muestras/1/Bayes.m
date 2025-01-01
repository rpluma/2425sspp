p1 = randn(100,2)*2+[10,20];
p2 = randn(100,2)*2+[20,10]; 
p3 = randn(100,2)*2+[10,10];
p4 = randn(100,2)*2+[20,20];
w1 = [p1;p2];
w2 = [p3;p4];
plot(c1(:,1),c1(:,2),'*')
hold on
plot(c2(:,1),c2(:,2),'*')
axis equal 
axis ([0 30 0 30])

n1 = size(w1,1);
n2 = size(w2,1);

m1 = mean(w1);
m2 = mean(w2);
C1 = zeros(size(w1,2),size(w1,2));
C2 = zeros(size(w1,2),size(w1,2));

for k = 1:n1
    C1 = C1 + w1(k,:)'*w1(k,:);
end
C1 = (C1/n1)-m1*m1';


for k = 1:n2
    C2 = C2 + w2(k,:)'*w2(k,:);
end
C2 = (C2/n2)-m2*m2';


d1 = log(n1/(n1+n2))-(1/2)*log(det(C1))-(1/2)<s