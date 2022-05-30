
class Movement{
  int direction;
  int now,to;
  int used[];
  int didx[][]={{0,1,2,3,4,5,6,7,8},
                {2,5,8,1,4,7,0,3,6},
                {8,7,6,5,4,3,2,1,0},
                {6,3,0,7,4,1,8,5,2}};
  int A[]= {-nx-1,-nx,-nx+1,-1,0,1,nx-1,nx,nx+1};
  int d[]= {-nx,-1,nx,1};
  int cost1[]= {2,1,2,3,0,3,3,4,3};
  int cost2[]= {2,1,2,5,0,5,4,4,4};
  Movement(int _direction,int _now,int _to, int []_used){
    direction= _direction;
    now= _now; to= _to;
    used= _used;
  }
  int testMove(){
    if(direction==-1) return 10;
    //print("(",now,",",map[now],",",direction,",",direction,")");
    if(used[map[now]+d[direction]]==1) return 10;
    int test_count=0;
    //空欄が0~8の位置にあるか
    int ix= wx-map[now]%nx, iy= wy-map[now]/nx;
    if(ix!=0) ix/=abs(ix);
    if(iy!=0) iy/=abs(iy);
    ix++; iy++;
    
    // 確定マスがあるので回り込んでいく場合: cost2[]を使う。
    // 回り込まなくても行ける場合: cost1[]を使う。
    int it=map[now]+A[didx[direction][ix]];
    //print(it,":");
    if(it<0||nx*ny<=it) test_count= cost2[didx[direction][iy*3+ix]];
    else if(used[it]==1) test_count= cost2[didx[direction][iy*3+ix]];
    else test_count= cost1[didx[direction][iy*3+ix]];
    
    //print(ix," ",iy," ",test_count,"\n");
    return test_count;
    
  }
  int distrans(int x){ //元の向きに戻す
    if(direction==0) return x;
    else if(direction==1) return ((nx-1-x%nx)*nx+x/nx);
    else if(direction==2) return (nx*nx-1)-x;
    else return (x%nx)*nx+(nx-1-x/nx);
  } 
  int trans(int x){ //上むきに変換
    if(direction==0) return x;
    else if(direction==1) return (x%nx)*nx+(nx-1-x/nx);
    else if(direction==2) return (nx*nx-1)-x;
    else return ((nx-1-x%nx)*nx+x/nx);
  }

  void prodMove(){
    //int x=0;
    //Function<Integer, Integer> trans= (x)->{
    //  if(state==0) return x;
    //  else if(state==1) return (nx-x%nx)*nx+x/nx;
    //  else if(state==2) return (nx-x%nx)*nx+(nx-x/nx);
    //  else return (x%nx)*nx+(nx-x/nx);
    //};
    // 上むきに変換
    int a= trans(map[now]); // 今
    int b= trans(wy*nx+wx); // 空マス
    //print(now," ",to);
    //print(now," ",a," ",b," ",distrans(a)," ",distrans(b),"パターン");
    if(a%nx==b%nx && b/nx<a/nx) { // 1
      //print(distrans(a));
      //print(1);
      move(distrans(a));
      
    }else if(b/nx==a/nx-1) { // 2
      //print(distrans(a-nx));
      //print(2);
      move(distrans(a-nx));
      
    }else if(b/nx<a/nx){ // 3
      //print(3);
      //print("(",distrans((a-nx)*nx+b%nx),")");
      if(used[distrans(b+(a%nx-b%nx))]==0){
        move(distrans(b+(a%nx-b%nx)));
      }else{
        move(distrans((a-nx)/nx*nx+b%nx));
      }
    }else if(b/nx==a/nx){ // 4
      //print(4);
      if(b-nx>=0 && a-nx>=0 && used[distrans(b-nx)]==0){
        move(distrans((a-nx)/nx*nx+b%nx));
      }else{
        move(distrans((a+nx)/nx*nx+b%nx));
      }
    }else if(a%nx==b%nx && a/nx<b/nx){ // 5
      //print(5);
      if(a-nx>=0 && b%nx!=nx-1 && used[distrans(b+1)]==0 && used[distrans(a-nx+1)]==0){
        move(distrans(b+1));
      }else{
        move(distrans(b-1));
      }
    }else{
      //print(6);
      if(used[distrans(a-nx-(a%nx-b%nx))]==0){
        move(distrans(a-nx-(a%nx-b%nx)));
      }else{
        if(a%nx<b%nx && a%nx!=0){
          move(distrans((b/nx)*nx+(a%nx-1)));
        }else{
          move(distrans((b/nx)*nx+(a%nx+1)));
        }
      }
    } 
  }
}
  
