import java.util.*;
class Assign{
  int n= cell*cell;
  int m= cell*cell;
  int pair[]= new int[n];
  long map[][];
  Assign(long _map[][]){
    map= _map;
  }
  int[] min_cost_match(){
    int[] toright= new int[n]; Arrays.fill(toright,-1);
    int[] toleft= new int[m]; Arrays.fill(toleft,-1);
    long[] ofsleft= new long[n]; Arrays.fill(ofsleft,(long)0);
    long[] ofsright= new long[m]; Arrays.fill(ofsright,(long)0);
    
    for(int r=0; r<n; r++){
      boolean[] left= new boolean[n],right= new boolean[m];
      Arrays.fill(left,false);
      Arrays.fill(right,false);
      int[] trace= new int[m]; Arrays.fill(trace, -1);
      int[] ptr= new int[m]; Arrays.fill(ptr, r);
      left[r]= true;
      for(;;){
        long d= Long.MAX_VALUE;
        for(int j=0; j<m; j++) if(!right[j])
          d= Math.min(d,map[ptr[j]][j] + ofsleft[ptr[j]] + ofsright[j]);
        for(int i=0; i<n; i++) if(left[i])
          ofsleft[i] -=d;
        for(int j=0; j<m; j++) if(right[j])
          ofsright[j] += d;
        int b= -1;
        for(int j=0; j<m; j++) if(!right[j] && map[ptr[j]][j] + ofsleft[ptr[j]] + ofsright[j]==0)
          b=j;

        trace[b]= ptr[b];
        int c= toleft[b];
        if(c<0){
          while(b>=0){
            int a= trace[b];
            int z= toright[a];
            toleft[b]= a;
            toright[a]= b;
            b= z;
          }
          break;
        }
        right[b]= left[c]= true;
        for(int j=0; j<m; j++) if(map[c][j] + ofsleft[c] + ofsright[j]<map[ptr[j]][j] + ofsleft[ptr[j]] + ofsright[j])
          ptr[j]= c;
        
      }
    }
    return toright;
  }
}
