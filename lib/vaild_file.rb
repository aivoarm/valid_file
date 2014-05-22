
#################################################################################################################################################################################################################
#####################################             ###########################################################################################################################################################################
##################################### USER CLASS  ############################################################################################################################################################################
#####################################             ############################################################################################################################################################################
#################################################################################################################################################################################################################

#-------------------------------------------------------------------------- 
# 
#  User Classes:  DataFile    
# 
#  methods: 
#       1. file_header - file header as array
#       2. all_file_to_array_with_line_num  - 
#-------------------------------------------------------------------------- 
 
class DataFile
    
 
    attr_accessor :name , :filepath, :type, :data, :obj, :fullpath
   
  def initialize(name= nil, filepath = "public/data"  , size = nil, data=[], obj={}, fullpath=nil )
     @filepath, @size, @data, @obj=   filepath, type, data, obj
     
     @name = name
  end
  
        def fullpath
                path=Rails.root.join(self.filepath, self.name)
        end
#========================================================================================================================
        def supplier
                ftype=self.ftype
                d= [find_all("VENDOR_NUMBER"), find_all("ACCOUNT_SEGMENT")]
        end
  
 
  
    #========================================================================================================================
      def check
     
        #obj = invoices_to_hash
      
      
      
       # find_all("INVOICE_NUMBER")
        #supplier
        layout_valid
      end
      
      
#========================================================================================================================    
  
   def layout_valid
       
       err_msg=[]
            rg={
                "gate14" => /^ *\d{14}$/,
                "gate8" => /^ *\d{8}$/,
                "amt" => /^(\+|-)?([0-9]+(\.[0-9]{1,2}$))/,
                "yn" => /^[YN]/, 
                "alfanum" => /^(.*\s+.*)+$/,
                "alf" => /^[A-Z]{2,}/
                }
                
        array_of_values.each do  |val|
        
        unless val[2]=="FILLER"    
         val[1]=="" ? err_msg << val : err_msg
        end
    end
                
                

        find_all("SOURCE").each do  |val|
            val << "SOURCE"
           unless val[1] =="uncommon"
            rg['alf'] =~ val[1].strip ? err_msg << "ok" : err_msg << val
           end
        end
        
        find_all("INVOICE_DATE").each do  |val|
            val << "INVOICE_DATE"
           unless val[1] =="uncommon"
            rg['gate8'] =~ val[1] ? err_msg << "ok" : err_msg << val
           end
        end
        
        
        find_all("INVOICE_AMOUNT").each do  |val|
            val << "INVOICE_AMOUNT"
           unless val[1] =="uncommon"
            rg['amt'] =~ val[1].strip ? err_msg << "ok" : err_msg << val
           end
        end
        
        find_all("ITEM_AMOUNT").each do  |val|
            val << 'ITEM_AMOUNT'
           unless val[1] =="uncommon"
            rg['amt'] =~ val[1].strip ? err_msg << "ok" : err_msg << val
           end
        end
        
        find_all("GST_AMOUNT").each do  |val|
            val << 'GST_AMOUNT'
           unless val[1] =="uncommon"
            rg['amt'] =~ val[1].strip ? err_msg << "ok" : err_msg << val
           end
        end
        
        find_all("PST_AMOUNT").each do  |val|
            val << "PST_AMOUNT"
           unless val[1] =="uncommon"
            rg['amt'] =~ val[1].strip ? err_msg << "ok" : err_msg << val
           end
        end
        
        find_all("FILE_DATE").each do  |val|
            val << "FILE_DATE"
           unless val[1] =="uncommon"
            rg['gate14'] =~ val[1].strip ? err_msg << "ok" : err_msg << val
           end
        end
        
        find_all("TAX_VALIDATED").each do  |val|
            val << "TAX_VALIDATED"
           unless val[1] =="uncommon"
            rg['yn'] =~ val[1].strip ? err_msg << "ok" : err_msg << val
           end
        end
        
        
        
        
        err=[]
err_msg.each do |e|
    unless e == 'ok'
    err << e
    end
    
    
end

err
    end


#========================================================================================================================    
 def array_of_values
     obj = invoices_to_hash
        data = []
     
     obj.each do |key, val|
    
                val["H"][0].each do |i| 
                  data  <<  [val["H"][0]['LINE_NUM'], i]
                end
                
                    val["D"].each do |e|
                        e.each do |i|
                        
                        data  << [e['LINE_NUM'],i]
                    end
                        
                     end
     end  
     
     data
 end
     
#========================================================================================================================
    def find_all(ftype, ltype=nil)
        obj = invoices_to_hash
        data = []
        
        obj.each do |key, val|
        
        
            if ltype.nil?
               if ftype == 'CURRENCY_CODE' || ftype == "INVOICE_DATE" || ftype == 'INVOICE_AMOUNT'  || ftype == 'COMPANY_CODE_SEGMENT' || ftype == 'TAX_VALIDATED'  || ftype == 'VENDOR_SITE_CODE' || ftype == 'COST_CENTER_SEGMENT' || ftype == 'ACCOUNT_SEGMENT' || ftype == 'SUB_ACCOUNT_SEGMENT'   
                   
                 val["H"][0][ftype].nil? ? input = "uncommon" : input = val["H"][0][ftype] 
                  data  <<  [val["H"][0]['LINE_NUM'], input]
                
                     val["D"].each do |e|
                        e[ftype].nil? ? input="uncommon" : input=e[ftype] 
                        data  << [e['LINE_NUM'],input]
                     end
                
                else
                    input = val["H"][0][ftype] 
                    data  <<  [val["H"][0]['LINE_NUM'], input]
                
                     val["D"].each do |e|
                        input=e[ftype] 
                        data  << [e['LINE_NUM'],input]
                     end
                end
                
            else
                
                
            
                if ltype == "H"
                    data  <<  [val["H"][0]['LINE_NUM'], input]
                end
                
                if ltype == "D"
                    val["D"].each do |e|
                     data  << [e['LINE_NUM'],input]
                    end
                end
            end
        end
        
        data
        
    end
    

#========================================================================================================================    
      
     def file_header
           
          layout= self.layout
          
          file_data=[]
          file = to_arr
         
            file.each do |file_line| # file_line each line from the file 
              
             if file_line[0]== "F"
                          tmp=[] 
                           
                             for i in layout[0]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      #data = verify_file_data(i[0],file_line[start,length])
                                      data = file_line[start,length]
                                      tmp << data
                             end     
                             file_data << tmp
               end
        end  
        return file_data[0]
    end 
 #========================================================================================================================       
      def invoices_to_hash
           
        layout= self.layout
          
        file_data=[]
        file = obj()
        h=0
        line_num = 1
        
        file.each do |k, file_line| # file_line each line from the file 
            
             if file_line[0] == "H"
                        h=h+1  
                            tmp=[]
                            tmp << h
                            tmp << ["LINE_NUM", line_num]
                                  for i in layout[1]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      
                                       tmp << [i[0],file_line[start,length]]
                                    end 
                             file_data << tmp
                             
              end
             if file_line[0] == "D"
                           tmp=[]
                           tmp << h
                           tmp << ["LINE_NUM", line_num]
                                  for i in layout[2]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      
                                      tmp << [i[0],file_line[start,length]]
                                    end 
                             file_data << tmp
              end
              line_num=line_num+1
        end  
           
   #...........................................  
     len=1
   file_data.each do |line| 
   if line[2][1] == "H" 
       len=len+1
   end
  end
  
     all={}
    
    for   n in 1..len-1
    
      
    header=[];  details=[]
    file_data.each do |line| 
        
            h=[]
            if line[2][1] == "H" && line[0] == n
              
                 line.each do |item|
                    next if item[0].is_a? Fixnum
                    h << {item[0] => item[1]}
                 end
                 header << h.inject(:merge)
            end
            
            d=[]
            if line[2][1] == "D" && line[0] == n
            
                line.each do |item|
                    next if item[0].is_a? Fixnum
                    d << {item[0] => item[1]}
                end
                #details << n
                details << d.inject(:merge)
            end
         end
         
      all[n]={"H" =>header, "D" => details}   
   
     
   end
         all
         
end
       
 #========================================================================================================================
      
       
      def all_file_to_array_with_line_num
           
          layout= self.layout
          
          file_data=[]
          file = obj()
         
            file.each do |k, file_line| # file_line each line from the file 
              
             case file_line[0]
        
                        when "F"
                          tmp=[] 
                           tmp.push(k)
                              for i in layout[0]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                      
                                      data = verify_file_data(i[0],file_line[start,length])
                                      
                                      data = [i[0],file_line[start,length]]
                                      
                                      tmp.push(data)
                             end     
                             file_data << tmp
                           
                            
                            #  file_data object {'line_num': 1, "FILE DATE":123123.....
                            
                        when "H"
                           tmp=[] 
                           tmp.push(k)
                              for i in layout[1]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                     
                                      data = verify_file_data(i[0],file_line[start,length])
                                      data = [i[0],file_line[start,length]]
                                      tmp.push(data)
                                     
                             end     
                             file_data << tmp
                           
                            
                        when "D"
                         
                          tmp=[] 
                           tmp.push(k)
                              for i in layout[2]
                                      start = i[1].to_i-1
                                      length = i[2].to_i
                                     
                                      data = verify_file_data(i[0],file_line[start,length])
                                      data = [i[0],file_line[start,length]]
                                      tmp.push(data)
                                     
                             end     
                             file_data << tmp
                     end
            end      
           return file_data
       end
       
  #=========HELPING FUNCTIONS=========================================================     
       
       
     
     def read(path = "public/layouts")
     
      filename = (self.right_layout)
    
       obj1, obj2, obj3=[], [], []
      
       
        arr = IO.readlines(File.join(path, filename))
      
      arr.each do |a|
                if a.split(',')[1] == "File_Header"
                     obj1 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
             return obj1
           end
             
               
      end

      
  #------------------------------------------------------------------

      def obj 
          count=0
          obj={}
        name=self.name
        filename=(name) 
        directory = self.filepath
        # create the file path
        path = File.join(directory, name)
        # read the file
        arr = IO.readlines(path)
        
            arr.each do |a|
                  obj[count]=a  
                  count=count+1  
            end
          return obj
      end
      
    def to_arr 
          arr=[]
         IO.readlines(File.join(self.filepath, self.name)).each do |a|
                  arr << a  
                 
        end
          return arr
      end
    #------------------------------------------------------------------
    
      
  
      def to_s
        "#{name}, #{obj}"
      end
  
   
    

#----------------------------------------------------------------------------------------------------

 def layout(path = "public/layouts")
     
         
         
      filename = (self.right_layout)
    
       obj1, obj2, obj3=[], [], []
      
       if  Dir[path+"*"].empty?
               return nil     
       end
        arr = IO.readlines(File.join(path, filename))
        
          #
            arr.each do |a|
                if a.split(',')[1] == "File_Header"
                     obj1 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
               
            end
    
            arr.each do |a|
                if a.split(',')[1] == "Invoice_Header"
                     obj2 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
                #tmp =[a[2],a[3],a[4]]
            end
          
          
           arr.each do |a|
                if a.split(',')[1] == "Invoice_Detail"
                     obj3 << [a.split(',')[2], a.split(',')[3], a.split(',')[4]]
                end 
                #tmp =[a[2],a[3],a[4]]
            end
            
    
    
     lay=[obj1, obj2, obj3]
     return lay
 end
   #------------------------------------------------------------------



 def sanitize_filename(name)
      
  name.gsub!(/^.*(\\|\/)/, '')
       name.gsub! /^.*(\\|\/)/, ''
 
 end
  

#------------------------------

def ftype
         
       file_lines=[]
         IO.readlines(File.join(self.filepath, self.name)).split(/\W+/).each do |line|
             
             
                record_type_valid = /^[FHD]/.match(line[0]) 
                if !record_type_valid 
                    return false
                end
                    
                 line.each do |i|
                      file_lines  << i
                     
                 end
         end
         if file_lines[0].include? "TEL"  
                            if file_lines[1][112, 300].include? "132011"  
                              ftype = "TEL BMOA"
                            elsif file_lines[1][111, 300].include? "00055"  
                               ftype = "TEL BMO CAD"
                            elsif file_lines[1][111, 300].include? "NTLTD"  
                                ftype = "TEL NB CAD"
                            else ftype = "UNDEFINED"
                            end
                            
             else
                            if file_lines[1][111, 300].include? "132011"  
                               ftype = "BMOA"
                            elsif file_lines[1][111, 300].include? "00055"  
                               ftype = "BMO CAD"
                            elsif file_lines[1][111, 300].include? "NTLTD"  
                                  ftype = "NB CAD"
                            else ftype = "UNDEFINED"
                            end
                                                             
            end
         
       
           return ftype
     end
     
#========================================================================================================================
     
    def right_layout(path = "public/layouts")
        test=[]
               layout = LayoutFile.all
        
        unless layout.empty?
        layout.each do |l|
         
          test << IO.readlines(File.join(path, l.filepath)).split(/\W+/)
          if self.ftype == test[0][0][0].split(',')[0]
              return l.filepath
           else 
               return false
          end
        
        end
        
    end
      
    
    end

#=====================================================================================

def write_valid_file
 
        layout= self.layout
        
    lfh=y_position[0] 
    lih=y_position[1] 
        
        
 
       
        
        
        
        validpath = Rails.root.join('public', 'done', self.name )
       path = Rails.root.join(self.filepath, self.name )
        
          File.open(validpath, 'wb') do |file|
              #read_data="" 
                  
                  File.open(path, 'r') do |read_data|
          #  read_data = path.read
            
            read_data.each do |line|   
            
                        if line[0] == "F"
                             line.gsub!(line[lfh], "Y")
                         
                        end
                        if line[0] == "H"
                             line.gsub!(line[lih], "Y")
                         end   
                      file.write(line)
              end   
               
            end
         end
        
            
    
  end
#======================
def y_position
        layout=self.layout
        lfh=0
        lih=0
      
      
       layout[0].each do |l|
              if l.include? "TAX_VALIDATED"
                  lfh = l[1].to_i-1
               end
            end 
        layout[1].each do |l|
              if l.include? "TAX_VALIDATED"
                  lih = l[1].to_i-1
               end
            end  
            
            return [lfh, lih]
  end

end #CLASS END

