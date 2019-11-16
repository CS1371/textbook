major = { 'C4' 1
          'D4' 1
          'E4' 1
          'F4' 1
          'G4' 1
          'A4' 1
          'B4' 1
          'C5' 1 };
      
minor = { 'C4' 1
          'D4' 1
          'EF4' 1
          'F4' 1
          'G4' 1
          'AF4' 1
          'BF4' 1
          'C5' 1 };
% parts for the Ramblin Wreck
soloPart= { 'G4' 1      %  1 I'm
            'F4' 0.5    %  2 a
            
            'EF4' 1     %  3 ram - 
            'EF4' 0.5   %  4 blin
            'EF4' 1     %  5 wreck 
            'F4' 0.5    %  6 from
            
            'G4' 1      %  7 Geor - 
            'G4' 0.5    %  8 gia
            'G4' 0.5    %  9 Tech 
            'F4' 0.5    % 10 and
            'EF4' 0.5   % 11 a
            
            'F4' 0.5    % 12 hell
            'G4' 0.5    % 13 of 
            'F4' 0.5    % 14 an
            'EF4' 1     % 15 en-
            'D4' 0.5    % 16 gin-
            
            'EF4' 2.5   % 17 eer
            'F4' 0.5    % 18 a
            
            'G4' 0.5    % 19 hell
            'G4' 0.5    % 20 of 
            'G4' 0.5    % 21 a
            'G4' 0.5    % 22 hell
            'G4' 0.5    % 23 of 
            'AF4' 0.5   % 24 a
            
            'BF4' 0.5   % 25 hell
            'BF4' 0.5   % 26 of 
            'BF4' 0.5   % 27 a
            'BF4' 0.5   % 28 hell
            'BF4' 0.5   % 29 of 
            'BF4' 0.5   % 30 a
            
            'BF4' 0.5   % 31 hell
            'F4' 0.5    % 32 of 
            'F4' 0.5    % 33 an
            'F4' 1      % 34 en-
            'F4' 0.5    % 35 gin-
            
            'F4' 2.5    % 36 eer
            'BF4' 0.5   % 37 like
            
            'C5' 1      % 38 all
            'AF4' 0.5   % 39 good 
            'C5' 1      % 40 jol-
            'AF4' 0.5   % 41 ly
            
            'C5' 0.5    % 42 fel-
            'EF5' 1.5   % 43 lows
            'R0' 0.5    % 44
            'C5' 0.5    % 45 I
            
            'BF4' 1     % 46 drink
            'C5' 0.5    % 47 my 
            'BF4' 1     % 48 whis-
            'G4' 0.5    % 49 ky
            
            'BF4' 1.5   % 50 clear
            'G4' 1      % 51 I'm
            'F4' 0.5    % 52 a
           
            'EF4' 1     % 53 ram - 
            'EF4' 0.5   % 54 blin
            'EF4' 1     % 55 wreck 
            'F4' 0.5    % 56 from
            
            'G4' 1      % 57 Geor - 
            'G4' 0.5    % 58 gia
            'G4' 0.5    % 59 Tech 
            'F4' 0.5    % 60 and
            'EF4' 0.5   % 61 a
            
            'F4' 0.5    % 62 hell
            'G4' 0.5    % 63 of 
            'F4' 0.5    % 64 an
            'EF4' 1     % 65 en-
            'D4' 0.5    % 66 gin-
            
            'EF4' 2     % 67 eer
            'R0'  1
          };  
    sopranoPart = soloPart;
    sopranoPart{67,2} = 1.5;
    sopranoPart(68,:) = {'EF5',0.5};
    sopranoPart(69,:) = {'R0'  1};
    sopranoPart{50,2} = 1;
    sopranoPart = [sopranoPart(1:50, :); {'R0' 0.5}; sopranoPart(51:end, :)];
    sopranoPart(29,:) = [];
    sopranoPart{28,2} = 1;
    sopranoPart(23,:) = [];
    sopranoPart{22,2} = 1;
alto1Part={ 'R0' 1.5      %  1 I'm
            
            'BF3' 1     %  3 ram - 
            'BF3' 0.5   %  4 blin
            'BF3' 1     %  5 wreck 
            'D4' 0.5    %  6 from
            
            'EF4' 1      %  7 Geor - 
            'EF4' 0.5    %  8 gia
            'EF4' 0.5    %  9 Tech 
            'R0' 1    % 10 and
            
            'R0' 3    % 12 hell
            
            'BF3' 1   % 17 eer
            'BF3' 0.5   % 17 eer
            'BF3' 1   % 17 eer
            'R0' 0.5    % 18 a
            
            'EF4' 0.5    % 19 hell
            'EF4' 0.5    % 20 of 
            'EF4' 0.5    % 21 a
            'EF4' 1    % 22 hell
            'D4' 0.5   % 24 a
            
            'EF4' 0.5   % 25 hell
            'EF4' 0.5   % 26 of 
            'EF4' 0.5   % 27 a
            'EF4' 1   % 28 hell
            'EF4' 0.5   % 30 a
            
            'D4' 0.5   % 31 hell
            'D4' 0.5    % 32 of 
            'D4' 0.5    % 33 an
            'EF4' 1      % 34 en-
            'EF4' 0.5    % 35 gin-
            
            'R0' 1    % 36 eer
            'EF4' 0.5    % 36 eer
            'D4' 1    % 36 eer
            'R0' 0.5   % 37 like
            
            'R0' 3      % 38 all
            
            'FS4' 0.5    % 42 fel-
            'FS4' 1.5     % 43 lows
            'R0'  1    % 44 I
            
            'R0' 3     % 45 drink
            
            'R0' 3   % 49 clear
            
            'BF3' 1     % 52 ram - 
            'BF3' 0.5   % 53 blin
            'BF3' 1     % 54 wreck 
            'D4' 0.5    % 55 from
            
            'EF4' 1      % 56 Geor - 
            'EF4' 0.5    % 57 gia
            'EF4' 0.5    % 58 Tech 
            'R0' 1    % 59 and
            
            'R0' 3    % 61 hell
            
            'BF3' 1.5     % 67 eer
            'G4' 0.5
            'R0'  1
          };  
    
alto2Part={ 'BF3' 1      %  1 I'm
            'AF3' 0.5    %  2 a
            
            'G3' 1     %  3 ram - 
            'G3' 0.5   %  4 blin
            'G3' 1     %  5 wreck 
            'AF3' 0.5    %  6 from
            
            'BF3' 1      %  7 Geor - 
            'BF3' 0.5    %  8 gia
            'BF3' 0.5    %  9 Tech 
            'R0' 0.5    % 10 and
            'R0' 0.5   % 11 a
            
            'AF3' 0.5    % 12 hell
            'BF3' 0.5    % 13 of 
            'AF3' 0.5    % 14 an
            'AF3' 1     % 15 en-
            'AF3' 0.5    % 16 gin-
            
            'G3' 1   % 17 eer
            'G3' 0.5   % 17 eer
            'G3' 1   % 17 eer
            'R0' 0.5    % 18 a
            
            'BF3' 0.5    % 19 hell
            'BF3' 0.5    % 20 of 
            'BF3' 0.5    % 21 a
            'BF3' 1    % 22 hell
            'BF3' 0.5   % 24 a
            
            'BF3' 0.5   % 25 hell
            'BF3' 0.5   % 26 of 
            'BF3' 0.5   % 27 a
            'BF3' 1   % 28 hell
            'BF3' 0.5   % 30 a
            
            'BF3' 0.5   % 31 hell
            'BF3' 0.5    % 32 of 
            'BF3' 0.5    % 33 an
            'BF3' 1      % 34 en-
            'BF3' 0.5    % 35 gin-
            
            'BF3' 1    % 36 eer
            'BF3' 0.5    % 36 eer
            'AF3' 1    % 36 eer
            'R0' 0.5   % 37 like
            
            'EF4' 1.5      % 38 all
            'EF4' 1.5   % 39 good 
            
            'EF4' 0.5    % 42 fel-
            'EF4' 1.5     % 43 lows
            'R0'  1    % 44 I
            
            'EF4' 1.5     % 45 drink
            'EF4' 1.5    % 46 my 
            
            'EF4' 1   % 49 clear
            'R0' 0.5
            'BF3' 1      % 50 I'm
            'AF3' 0.5    % 51 a
            
            'G3' 1     % 52 ram - 
            'G3' 0.5   % 53 blin
            'G3' 1     % 54 wreck 
            'AF3' 0.5    % 55 from
            
            'BF3' 1      % 56 Geor - 
            'BF3' 0.5    % 57 gia
            'BF3' 0.5    % 58 Tech 
            'R0' 1    % 59 and
            
            'AF3' 0.5    % 61 hell
            'BF3' 0.5    % 62 of 
            'AF3' 0.5    % 63 an
            'AF3' 1     % 64 en-
            'AF3' 0.5    % 65 gin-
            
            'G3' 1.5     % 67 eer
            'EF4' 0.5
            'R0'  1
          };  
      
tenorPart={ 'BF2' 1.5    %  2 a
            
            'EF3' 1.5   %  4 ramb-
            'BF2' 1.5    %  6 wreck
            
            'EF3' 1.5   %  4 Georgia
            'BF2' 1.5    %  6 Tech
            
            'F3' 1.5   %  hell
            'BF2' 1.5    %  en-
           
            'EF3' 1   % 17 eer
            'BF2' 0.5   % 17 eer
            'EF1' 1   % 17 eer
            'R0' 0.5    % 18 a
            
            'EF3' 2.5    % 19 hell
            'F3' 0.5   % 24 a
            
            'G3'  2.5   % 25 hell
            'GF3' 0.5   % 30 a
            
            'F3' 1.5   % 31 hell
            'C3' 1.5    % 32 of 
            
            'BF2' 1    % 36 eer
            'C3' 0.5    % 36 eer
            'D3' 1    % 36 eer
            'R0' 0.5   % 37 like
            
            'AF3' 1.5      % 38 all
            'AF3' 1.5   % 39 good 
            
            'A3' 1.5      % 38 all
            'A3' 1.5   % 39 good 
            
            'BF3' 1.5      % 38 all
            'G3' 1.5   % 39 good 
            
            'EF3' 1   % 49 clear
            'R0' 0.5
            'BF2' 1.5    % 51 a
            
            'EF3' 1.5   %  4 ramb-
            'BF2' 1.5    %  6 wreck
            
            'EF3' 1.5   %  4 Georgia
            'BF2' 1.5    %  6 Tech
            
            'F3' 1.5   %  hell
            'BF2' 1.5    %  en-
            
            'EF3' 0.5     % 67 eer
            'BF2' 0.5
            'G2'  0.5
            'EF2'  0.5
            'R0'  1
          };  
bassPart={ 'BF1' 1.5    %  2 a
            
            'EF2' 1.5   %  4 ramb-
            'BF1' 1.5    %  6 wreck
            
            'EF2' 1.5   %  4 Georgia
            'BF1' 1.5    %  6 Tech
            
            'F2' 1.5   %  hell
            'BF1' 1.5    %  en-
           
            'EF2' 1   % 17 eer
            'R0' 0.5   % 17 eer
            'EF2' 1   % 17 eer
            'R0' 0.5    % 18 a
            
            'EF2' 2.5    % 19 hell
            'F2' 0.5   % 24 a
            
            'G2'  2.5   % 25 hell
            'GF2' 0.5   % 30 a
            
            'F2' 1.5   % 31 hell
            'C2' 1.5    % 32 of 
            
            'BF1' 1    % 36 eer
            'C2' 0.5    % 36 eer
            'D2' 1    % 36 eer
            'R0' 0.5   % 37 like
            
            'AF2' 1.5      % 38 all
            'AF2' 1.5   % 39 good 
            
            'A2' 1.5      % 38 all
            'A2' 1.5   % 39 good 
            
            'BF2' 1.5      % 38 all
            'G2' 1.5   % 39 good 
            
            'EF2' 1   % 49 clear
            'R0' 0.5
            'BF1' 1.5    % 51 a
            
            'EF2' 1.5   %  4 ramb-
            'BF1' 1.5    %  6 wreck
            
            'EF2' 1.5   %  4 Georgia
            'BF1' 1.5    %  6 Tech
            
            'F2' 1.5   %  hell
            'BF1' 1.5    %  en-
            
            'EF2' 1.5     % 67 eer
            'EF2'  0.5
            'R0'  1
          };  
      
