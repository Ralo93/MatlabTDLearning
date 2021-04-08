function percentage = checkTable(t)
  # apparently octave has some strange (or cool..) datatypes
  # what works is to convert the .mat file, which seems to be a struct to cell and then to mat again  
  # now this function can be called with mat files
  
  
  if (isstruct(t))
    
    tt = struct2cell(t);
    ttt = cell2mat(tt);
    sizee = size(ttt, 1) * size(ttt, 2);
    fprintf('rows: %d \n', size(ttt, 1));
    fprintf('columns: %d \n', size(ttt, 2));
    fprintf('table size: %d \n', sizee);

    positiveEntries = find(ttt(:)<=0);
    percentage = length(positiveEntries)/sizee;
    fprintf('Percentage learned: %d \n',percentage);
    
    return
    
  endif
  
  
  if (iscell(t))
    
    tt = cell2mat(t);
    sizee = size(tt, 1) * size(tt, 2);
    fprintf('table size: %d \n', sizee);

    positiveEntries = find(tt(:)<=0);
    percentage = length(positiveEntries)/sizee;
    #fprintf('Percentage learned: %d \n',percentage);
    
    return;
    
    
  endif
  
    
  sizee = size(t, 1) * size(t, 2);
  fprintf('table size: %d \n', sizee);

  positiveEntries = find(t(:)<=0);
  percentage = length(positiveEntries)/sizee;
  #fprintf('Percentage learned: %d \n',percentage);
  
  return
  
  end