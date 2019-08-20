section Eurostat_API;

[DataSource.Kind="Eurostat_API", Publish="Eurostat_API.Publish"]
//shared Eurostat_API.Contents = (url as text) as table =>
shared Eurostat_API.Contents = Value.ReplaceType(Eurostat_APIImpl, Eurostat_APIType);


Eurostat_APIType = type function (
    message as (type text meta [
        Documentation.FieldCaption = "Use Eurostat's query builder to construct URL",
        Documentation.FieldDescription = "https://ec.europa.eu/eurostat/web/json-and-unicode-web-services/getting-started/query-builder",
        Documentation.SampleValues = {"http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/nama_10_gdp?na_item=B1GQ&precision=1&unit=CP_MEUR"}// tu dać przyklad api
     ])
//      ,
//     optional count as (type number meta [
//         Documentation.FieldCaption = "Count",
//         Documentation.FieldDescription = "Number of times to repeat the message",
//         Documentation.AllowedValues = { 1, 2, 3 }
//     ])
)
   as table meta [
        Documentation.Name = "Eurostat API Connector",
        Documentation.LongDescription = "Eurostat API Connector",
        Documentation.Examples = {[
            Description = "Returns a table with 'Hello world' repeated 2 times",
            Code = "HelloWorldWithDocs.Contents(""Hello world"", 2)",
            Result = "#table({""Column1""}, {{""Hello world""}, {""Hello world""}})"
        ],[
            Description = "Another example, new message, new count!",
            Code = "HelloWorldWithDocs.Contents(""Goodbye"", 1)",
            Result = "#table({""Column1""}, {{""Goodbye""}})"
        ]}
    ];


Eurostat_APIImpl = (url as text) as table =>
    let

    Source_url =  url,//"http://ec.europa.eu/eurostat/wdds/rest/data/v2.1/json/en/ilc_peps01?sinceTimePeriod=2016&precision=1&age=Y15-29&sex=F&sex=M&geo=FR&geo=PL&unit=PC",
    

    Source = Source_url,
    ParseJSON = try Json.Document(Web.Contents(Source)) otherwise Source,
	
    dimension = ParseJSON [dimension],
    id = ParseJSON [id],
    //id= List.RemoveMatchingItems(ParseJSON [id],{"unit"}),
    size= ParseJSON [size],
    values = ParseJSON [value],  

    label = ParseJSON [label],
    href = ParseJSON [href],
    source = ParseJSON [source],
    updated = ParseJSON [updated],
    extension = ParseJSON [extension],
    //extension_table = Table.FromRecords(extension),

    extension_datasetID = extension[datasetId],
    extension_lang = extension[lang],
    extension_description = extension[description],

    extension_table = Table.FromRows({{"datasetID",Text.From(extension_datasetID)},{"description",Text.From(extension_description)},{"lang",Text.From(extension_lang)}},{"Name","Value"}),

    info_table = Table.FromRecords({[Name="label", Value=label],[Name="href", Value=href],[Name="source", Value=source],[Name="updated", Value=updated]}),
    info = Table.Combine({info_table,extension_table}),
 //   info = Table.Combine({extension_table}),
   //info = Table.FromValue({label,href,source,updated}),

    dimension_table = Record.ToTable(dimension),
   // dimension_table = Table.RemoveMatchingRows(dimension_table_tmp,{[Name = "unit"]}, "Name"),

    dimension_count = Table.RowCount(dimension_table),

 //  value_table = Record.ToTable(values),
    

   tables_list = List.Generate (  
                                    ()=> [i=0 ,result=Record.ToTable(dimension_table{i})],
                                    each [i] < dimension_count,  //<5
                                    each[   result= Record.ToTable(dimension_table{i}), i=[i]+1]
                                   ,each[result]
                                 ), 
								 


    counter = dimension_count,



    source_counter = 
             if counter = 2 then source2
        else if counter = 3 then source3
        else if counter = 4 then source4
        else if counter = 5 then source5
        else if counter = 6 then source6
        else if counter = 7 then source7
        else if counter = 8 then source8
          else "Error",

    source2 = #table({"Name","Data","ItemKind","ItemName","IsLeaf"},{
        {id{0},GetTable(tables_list{0}{1}[Value][category],Text.From(id{0})) , "Table", "Table" , true},
        {id{1},GetTable(tables_list{1}{1}[Value][category],Text.From(id{1})) , "Table", "Table" , true},
        {"values",GetTableValues(values,"values") , "Table", "Table" , true},
        {"_Relations",GetTableOmni2(tables_list, id) , "Table", "Table" , true},
        {"Information",info , "Table", "Table" , true}
        }),

    source3 = #table({"Name","Data","ItemKind","ItemName","IsLeaf"},{
        {id{0},GetTable(tables_list{0}{1}[Value][category],Text.From(id{0})) , "Table", "Table" , true},
        {id{1},GetTable(tables_list{1}{1}[Value][category],Text.From(id{1})) , "Table", "Table" , true},
        {id{2},GetTable(tables_list{2}{1}[Value][category],Text.From(id{2})) , "Table", "Table" , true},
        {"values",GetTableValues(values,"values") , "Table", "Table" , true},
        {"Relations",GetTableOmni3(tables_list, id) , "Table", "Table" , true},
        {"Information",info , "Table", "Table" , true}
        }),
// 
    source4 = #table({"Name","Data","ItemKind","ItemName","IsLeaf"},{
        {id{0},GetTable(tables_list{0}{1}[Value][category],Text.From(id{0})) , "Table", "Table" , true},
        {id{1},GetTable(tables_list{1}{1}[Value][category],Text.From(id{1})) , "Table", "Table" , true},
        {id{2},GetTable(tables_list{2}{1}[Value][category],Text.From(id{2})) , "Table", "Table" , true},
        {id{3},GetTable(tables_list{3}{1}[Value][category],Text.From(id{3})) , "Table", "Table" , true},
        {"values",GetTableValues(values,"values") , "Table", "Table" , true},
        {"_Relations",GetTableOmni4(tables_list, id) , "Table", "Table" , true},
        {"Information",info , "Table", "Table" , true}
        }),

    source5 = #table({"Name","Data","ItemKind","ItemName","IsLeaf"},{
         //  {"tabela",#table({"a","b"},{0,0}), "Table", "Table" , true},        
        {id{0},GetTable(tables_list{0}{1}[Value][category],Text.From(id{0})) , "Table", "Table" , true},
        {id{1},GetTable(tables_list{1}{1}[Value][category],Text.From(id{1})) , "Table", "Table" , true},
        {id{2},GetTable(tables_list{2}{1}[Value][category],Text.From(id{2})) , "Table", "Table" , true},
        {id{3},GetTable(tables_list{3}{1}[Value][category],Text.From(id{3})) , "Table", "Table" , true},
        {id{4},GetTable(tables_list{4}{1}[Value][category],Text.From(id{4})) , "Table", "Table" , true},
        {"values",GetTableValues(values,"values") , "Table", "Table" , true},
        {"_Relations",GetTableOmni5(tables_list, id) , "Table", "Table" , true},
        {"Information",info , "Table", "Table" , true}
        }),

    source6 = #table({"Name","Data","ItemKind","ItemName","IsLeaf"},{
        {id{0},GetTable(tables_list{0}{1}[Value][category],Text.From(id{0})) , "Table", "Table" , true},
        {id{1},GetTable(tables_list{1}{1}[Value][category],Text.From(id{1})) , "Table", "Table" , true},
        {id{2},GetTable(tables_list{2}{1}[Value][category],Text.From(id{2})) , "Table", "Table" , true},
        {id{3},GetTable(tables_list{3}{1}[Value][category],Text.From(id{3})) , "Table", "Table" , true},
        {id{4},GetTable(tables_list{4}{1}[Value][category],Text.From(id{4})) , "Table", "Table" , true},
        {id{5},GetTable(tables_list{5}{1}[Value][category],Text.From(id{5})) , "Table", "Table" , true},
        {"values",GetTableValues(values,"values") , "Table", "Table" , true},
        {"_Relations",GetTableOmni6(tables_list, id) , "Table", "Table" , true},
        {"Information",info , "Table", "Table" , true}
        }),

    source7 = #table({"Name","Data","ItemKind","ItemName","IsLeaf"},{
        {id{0},GetTable(tables_list{0}{1}[Value][category],Text.From(id{0})) , "Table", "Table" , true},
        {id{1},GetTable(tables_list{1}{1}[Value][category],Text.From(id{1})) , "Table", "Table" , true},
        {id{2},GetTable(tables_list{2}{1}[Value][category],Text.From(id{2})) , "Table", "Table" , true},
        {id{3},GetTable(tables_list{3}{1}[Value][category],Text.From(id{3})) , "Table", "Table" , true},
        {id{4},GetTable(tables_list{4}{1}[Value][category],Text.From(id{4})) , "Table", "Table" , true},
        {id{5},GetTable(tables_list{5}{1}[Value][category],Text.From(id{5})) , "Table", "Table" , true},
        {id{6},GetTable(tables_list{6}{1}[Value][category],Text.From(id{6})) , "Table", "Table" , true},
        {"values",GetTableValues(values,"values") , "Table", "Table" , true},
        {"_Relations",GetTableOmni7(tables_list, id) , "Table", "Table" , true},
        {"Information",info , "Table", "Table" , true}
        }),

    source8 = #table({"Name","Data","ItemKind","ItemName","IsLeaf"},{
        {id{0},GetTable(tables_list{0}{1}[Value][category],Text.From(id{0})) , "Table", "Table" , true},
        {id{1},GetTable(tables_list{1}{1}[Value][category],Text.From(id{1})) , "Table", "Table" , true},
        {id{2},GetTable(tables_list{2}{1}[Value][category],Text.From(id{2})) , "Table", "Table" , true},
        {id{3},GetTable(tables_list{3}{1}[Value][category],Text.From(id{3})) , "Table", "Table" , true},
        {id{4},GetTable(tables_list{4}{1}[Value][category],Text.From(id{4})) , "Table", "Table" , true},
        {id{5},GetTable(tables_list{5}{1}[Value][category],Text.From(id{5})) , "Table", "Table" , true},
        {id{6},GetTable(tables_list{6}{1}[Value][category],Text.From(id{6})) , "Table", "Table" , true},
        {id{7},GetTable(tables_list{7}{1}[Value][category],Text.From(id{7})) , "Table", "Table" , true},
        {"values",GetTableValues(values,"values") , "Table", "Table" , true},
        {"_Relations",GetTableOmni8(tables_list, id) , "Table", "Table" , true},
        {"Information",info , "Table", "Table" , true}
        }),


        navTable = Table.ToNavigationTable(source_counter, {"Name"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in

     navTable;

func_r = (tabela) => let

        table_od_dim = Record.ToTable(tabela),
        list_od_dim_col_names = Table.ColumnNames(Table.FromRecords(table_od_dim[Value])),
        table_dim_res= Table.ExpandRecordColumn(table_od_dim,"Value", list_od_dim_col_names),
        transposed_table = Table.Transpose(table_dim_res),
        headers_table = Table.PromoteHeaders(transposed_table, [PromoteAllScalars=true])

    in
    headers_table;


GetTableOmni8 = (tables_list,  id) as table =>
let
  
    tbl1 = func_r(tables_list{7}{1}[Value][category]), 
    tbl2 = func_r(tables_list{6}{1}[Value][category]), 
    tbl3 = func_r(tables_list{5}{1}[Value][category]), 
    tbl4 = func_r(tables_list{4}{1}[Value][category]), 
    tbl5 = func_r(tables_list{3}{1}[Value][category]), 
    tbl6 = func_r(tables_list{2}{1}[Value][category]), 
    tbl7 = func_r(tables_list{1}{1}[Value][category]), 
    tbl8 = func_r(tables_list{0}{1}[Value][category]), 
 
    list1 = tbl1[index], 
    list2 = tbl2[index], 
    list3 = tbl3[index], 
    list4 = tbl4[index], 
    list5 = tbl5[index],  
    list6 = tbl6[index], 
    list7 = tbl7[index], 
    list8 = tbl8[index], 

    kol_a = Text.Combine({"index_",id{7}},""),
    kol_b = Text.Combine({"index_",id{6}},""),
    kol_c = Text.Combine({"index_",id{5}},""),
    kol_d = Text.Combine({"index_",id{4}},""),
    kol_e = Text.Combine({"index_",id{3}},""),
    kol_f = Text.Combine({"index_",id{2}},""),
    kol_g = Text.Combine({"index_",id{1}},""),
    kol_h = Text.Combine({"index_",id{0}},""),

    table1 = #table({"a","b","c","d","e","f","g","h"},{}),   

  //  list_tmp = {99},

    func = (tabela,val1) => let  
          list_tmp= List.Accumulate(list7, tabela , (state,current)=> func1(state,current,val1)) //-> 0: c,d  ,  -> 1: c,d
    in
    list_tmp,   

    func1 = (tabela,val2,val1) => let              
          list_tmp= List.Accumulate(list6, tabela , (state,current)=> func2(state,current,val2,val1))  
    in
   list_tmp,    

   func2 = (tabela,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list5, tabela , (state,current)=> func3(state,current,val3,val2,val1))                       
    in 
   list_tmp,  

   func3 = (tabela,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list4, tabela , (state,current)=> func4(state,current,val4,val3,val2,val1))                         
    in 
   list_tmp,  

   func4 = (tabela,val5,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list3, tabela , (state,current)=> func5(state,current,val5,val4,val3,val2,val1))                         
    in 
   list_tmp,   

   func5 = (tabela,val6,val5,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list2, tabela , (state,current)=> func6(state,current,val6,val5,val4,val3,val2,val1))                         
    in 
   list_tmp,   

   func6 = (tabela,val7,val6,val5,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list1, tabela , (state,current)=> func7(state,current,val7,val6,val5,val4,val3,val2,val1))                         
    in 
   list_tmp,   
   
   func7 = (tabela,val8,val7,val6,val5,val4,val3,val2,val1) => let     
        res = Table.InsertRows(tabela,0,{[a = val8, b = val7 , c= val6, d= val5, e=val4, f=val3, g=val2, h=val1]})               
    in
   res, 

   result1 = List.Accumulate(list8, table1, (state,current)=> func(state,current)),
   result2 = Table.RenameColumns(Table.ReverseRows(result1),{{"a",Text.From(kol_a)} ,{"b",Text.From(kol_b)},{"c",Text.From(kol_c)},{"d",Text.From(kol_d)},{"e",Text.From(kol_e)},{"f",Text.From(kol_f)},{"g",Text.From(kol_g)},{"h",Text.From(kol_g)}}),
   result =Table.AddIndexColumn(result2, "index_values", 0, 1)
in
  result;





GetTableOmni7 = (tables_list,  id) as table =>
let
  
    tbl1 = func_r(tables_list{6}{1}[Value][category]), 
    tbl2 = func_r(tables_list{5}{1}[Value][category]), 
    tbl3 = func_r(tables_list{4}{1}[Value][category]), 
    tbl4 = func_r(tables_list{3}{1}[Value][category]), 
    tbl5 = func_r(tables_list{2}{1}[Value][category]), 
    tbl6 = func_r(tables_list{1}{1}[Value][category]), 
    tbl7 = func_r(tables_list{0}{1}[Value][category]), 
 
    list1 = tbl1[index], 
    list2 = tbl2[index], 
    list3 = tbl3[index], 
    list4 = tbl4[index], 
    list5 = tbl5[index],  
    list6 = tbl6[index], 
    list7 = tbl7[index], 

    kol_a = Text.Combine({"index_",id{6}},""),
    kol_b = Text.Combine({"index_",id{5}},""),
    kol_c = Text.Combine({"index_",id{4}},""),
    kol_d = Text.Combine({"index_",id{3}},""),
    kol_e = Text.Combine({"index_",id{2}},""),
    kol_f = Text.Combine({"index_",id{1}},""),
    kol_g = Text.Combine({"index_",id{0}},""),

    table1 = #table({"a","b","c","d","e","f","g"},{}),   

  //  list_tmp = {99},

    func = (tabela,val1) => let  
          list_tmp= List.Accumulate(list6, tabela , (state,current)=> func1(state,current,val1)) //-> 0: c,d  ,  -> 1: c,d
    in
    list_tmp,   

    func1 = (tabela,val2,val1) => let              
          list_tmp= List.Accumulate(list5, tabela , (state,current)=> func2(state,current,val2,val1))  
    in
   list_tmp,    

   func2 = (tabela,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list4, tabela , (state,current)=> func3(state,current,val3,val2,val1))                       
    in 
   list_tmp,  

   func3 = (tabela,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list3, tabela , (state,current)=> func4(state,current,val4,val3,val2,val1))                         
    in 
   list_tmp,  

   func4 = (tabela,val5,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list2, tabela , (state,current)=> func5(state,current,val5,val4,val3,val2,val1))                         
    in 
   list_tmp,   

   func5 = (tabela,val6,val5,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list1, tabela , (state,current)=> func6(state,current,val6,val5,val4,val3,val2,val1))                         
    in 
   list_tmp,   
   
   func6 = (tabela,val7,val6,val5,val4,val3,val2,val1) => let     
        res = Table.InsertRows(tabela,0,{[a = val7, b = val6 , c= val5, d= val4, e=val3, f=val2, g=val1]})               
    in
   res, 

   result1 = List.Accumulate(list7, table1, (state,current)=> func(state,current)),
   result2 = Table.RenameColumns(Table.ReverseRows(result1),{{"a",Text.From(kol_a)} ,{"b",Text.From(kol_b)},{"c",Text.From(kol_c)},{"d",Text.From(kol_d)},{"e",Text.From(kol_e)},{"f",Text.From(kol_f)},{"g",Text.From(kol_g)}}),
   result =Table.AddIndexColumn(result2, "index_values", 0, 1)
in
  result;



GetTableOmni6 = (tables_list,  id) as table =>
let
  
    tbl1 = func_r(tables_list{5}{1}[Value][category]), 
    tbl2 = func_r(tables_list{4}{1}[Value][category]), 
    tbl3 = func_r(tables_list{3}{1}[Value][category]), 
    tbl4 = func_r(tables_list{2}{1}[Value][category]), 
    tbl5 = func_r(tables_list{1}{1}[Value][category]), 
    tbl6 = func_r(tables_list{0}{1}[Value][category]), 
 
    list1 = tbl1[index], 
    list2 = tbl2[index], 
    list3 = tbl3[index], 
    list4 = tbl4[index], 
    list5 = tbl5[index],  
    list6 = tbl6[index], 

    kol_a = Text.Combine({"index_",id{5}},""),
    kol_b = Text.Combine({"index_",id{4}},""),
    kol_c = Text.Combine({"index_",id{3}},""),
    kol_d = Text.Combine({"index_",id{2}},""),
    kol_e = Text.Combine({"index_",id{1}},""),
    kol_f = Text.Combine({"index_",id{0}},""),


    table1 = #table({"a","b","c","d","e","f"},{}),   

   // list_tmp = {99},

    func = (tabela,val1) => let  
          list_tmp= List.Accumulate(list5, tabela , (state,current)=> func1(state,current,val1)) //-> 0: c,d  ,  -> 1: c,d
    in
    list_tmp,   

    func1 = (tabela,val2,val1) => let              
          list_tmp= List.Accumulate(list4, tabela , (state,current)=> func2(state,current,val2,val1))  
    in
   list_tmp,    

   func2 = (tabela,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list3, tabela , (state,current)=> func3(state,current,val3,val2,val1))                       
    in 
   list_tmp,  

   func3 = (tabela,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list2, tabela , (state,current)=> func4(state,current,val4,val3,val2,val1))                         
    in 
   list_tmp,  

   func4 = (tabela,val5,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list1, tabela , (state,current)=> func5(state,current,val5,val4,val3,val2,val1))                         
    in 
   list_tmp,   
   
   func5 = (tabela,val6,val5,val4,val3,val2,val1) => let     
        res = Table.InsertRows(tabela,0,{[a = val6, b = val5 , c= val4, d= val3, e=val2, f=val1]})               
    in
   res, 

   result1 = List.Accumulate(list6, table1, (state,current)=> func(state,current)),
   result2 = Table.RenameColumns(Table.ReverseRows(result1),{{"a",Text.From(kol_a)} ,{"b",Text.From(kol_b)},{"c",Text.From(kol_c)},{"d",Text.From(kol_d)},{"e",Text.From(kol_e)},{"f",Text.From(kol_f)}}),
   result =Table.AddIndexColumn(result2, "index_values", 0, 1)
in
  result;



GetTableOmni5 = (tables_list,  id) as table =>
let
  
//     tbl1 = func_r(tables_list{0}{1}[Value][category]), //time
//     tbl2 = func_r(tables_list{1}{1}[Value][category]), //geo 
//     tbl3 = func_r(tables_list{2}{1}[Value][category]), //sex 
//     tbl4 = func_r(tables_list{3}{1}[Value][category]), //age
//     tbl5 = func_r(tables_list{4}{1}[Value][category]), //unit 

// 
    tbl1 = func_r(tables_list{4}{1}[Value][category]), //time
    tbl2 = func_r(tables_list{3}{1}[Value][category]), //geo 
    tbl3 = func_r(tables_list{2}{1}[Value][category]), //sex 
    tbl4 = func_r(tables_list{1}{1}[Value][category]), //age
    tbl5 = func_r(tables_list{0}{1}[Value][category]), //unit 
 
    list1 = tbl1[index], //time
    list2 = tbl2[index], //geo 
    list3 = tbl3[index], //sex 
    list4 = tbl4[index], //age
    list5 = tbl5[index], //unit 

    kol_a = Text.Combine({"index_",id{4}},""),
    kol_b = Text.Combine({"index_",id{3}},""),
    kol_c = Text.Combine({"index_",id{2}},""),
    kol_d = Text.Combine({"index_",id{1}},""),
    kol_e = Text.Combine({"index_",id{0}},""),

    table1 = #table({"a","b","c","d","e"},{}),   

   // list_tmp = {99},

    func = (tabela,val1) => let  
          list_tmp= List.Accumulate(list4, tabela , (state,current)=> func1(state,current,val1)) //-> 0: c,d  ,  -> 1: c,d
    in
    list_tmp,   

    func1 = (tabela,val2,val1) => let              
          list_tmp= List.Accumulate(list3, tabela , (state,current)=> func2(state,current,val2,val1))  
    in
   list_tmp,    

   func2 = (tabela,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list2, tabela , (state,current)=> func3(state,current,val3,val2,val1))    
                       
    in 
   list_tmp,  

   func3 = (tabela,val4,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list1, tabela , (state,current)=> func4(state,current,val4,val3,val2,val1))    
                       
    in 
   list_tmp,  

   func4 = (tabela,val5,val4,val3,val2,val1) => let     
        res = Table.InsertRows(tabela,0,{[a = val5, b = val4 , c= val3, d= val2, e=val1]})               
    in
   res,     

   result1 = List.Accumulate(list5, table1, (state,current)=> func(state,current)),
   result2 = Table.RenameColumns(Table.ReverseRows(result1),{{"a",Text.From(kol_a)} ,{"b",Text.From(kol_b)},{"c",Text.From(kol_c)},{"d",Text.From(kol_d)},{"e",Text.From(kol_e)}}),
   result =Table.AddIndexColumn(result2, "index_values", 0, 1)
in
  result;


GetTableOmni4 = (tables_list,  id) as table =>
let
  
    tbl1 = func_r(tables_list{3}{1}[Value][category]), 
    tbl2 = func_r(tables_list{2}{1}[Value][category]), 
    tbl3 = func_r(tables_list{1}{1}[Value][category]), 
    tbl4 = func_r(tables_list{0}{1}[Value][category]), 
 
    list1 = tbl1[index], 
    list2 = tbl2[index], 
    list3 = tbl3[index], 
    list4 = tbl4[index], 

    kol_a = Text.Combine({"index_",id{3}},""),
    kol_b = Text.Combine({"index_",id{2}},""),
    kol_c = Text.Combine({"index_",id{1}},""),
    kol_d = Text.Combine({"index_",id{0}},""),

    table1 = #table({"a","b","c","d"},{}),   

   // list_tmp = {99},

    func = (tabela,val1) => let  
          list_tmp= List.Accumulate(list3, tabela , (state,current)=> func1(state,current,val1)) 
    in
    list_tmp,   

    func1 = (tabela,val2,val1) => let              
          list_tmp= List.Accumulate(list2, tabela , (state,current)=> func2(state,current,val2,val1))  
    in
   list_tmp,    

   func2 = (tabela,val3,val2,val1) => let  
         list_tmp =   List.Accumulate(list1, tabela , (state,current)=> func3(state,current,val3,val2,val1))    
                       
    in 
   list_tmp,  

   func3 = (tabela,val4,val3,val2,val1) => let     
        res = Table.InsertRows(tabela,0,{[a = val4, b = val3 , c= val2, d= val1]})               
    in
   res,     

   result1 = List.Accumulate(list4, table1, (state,current)=> func(state,current)),
   result2 = Table.RenameColumns(Table.ReverseRows(result1),{{"a",Text.From(kol_a)} ,{"b",Text.From(kol_b)},{"c",Text.From(kol_c)},{"d",Text.From(kol_d)}}),
   result =Table.AddIndexColumn(result2, "index_values", 0, 1)
in
  result;


GetTableOmni3 = (tables_list,  id) as table =>
let

    tbl1 = func_r(tables_list{2}{1}[Value][category]), 
    tbl2 = func_r(tables_list{1}{1}[Value][category]), 
    tbl3 = func_r(tables_list{0}{1}[Value][category]), 
   
    list1 = tbl1[index], 
    list2 = tbl2[index], 
    list3 = tbl3[index], 
 
    kol_a = Text.Combine({"index_",id{2}},""),
    kol_b = Text.Combine({"index_",id{1}},""),
    kol_c = Text.Combine({"index_",id{0}},""),

    table1 = #table({"a","b","c"},{}), 

   // list_tmp = {99},

    func = (tabela,val1) => let  
          list_tmp= List.Accumulate(list2, tabela , (state,current)=> func1(state,current,val1)) 
    in
    list_tmp,   

    func1 = (tabela,val2,val1) => let              
          list_tmp= List.Accumulate(list1, tabela , (state,current)=> func2(state,current,val2,val1))  
    in
   list_tmp,    

   func2 = (tabela,val3,val2,val1) => let  
      res = Table.InsertRows(tabela,0,{[a = val3, b = val2 , c= val1]})               
    in
   res, 

   result1 = List.Accumulate(list3, table1, (state,current)=> func(state,current)),
   result2 = Table.RenameColumns(Table.ReverseRows(result1),{{"a",Text.From(kol_a)} ,{"b",Text.From(kol_b)},{"c",Text.From(kol_c)}}),
   result =Table.AddIndexColumn(result2, "index_values", 0, 1)
in
  result;


  GetTableOmni2 = (tables_list,  id) as table =>
let

    tbl1 = func_r(tables_list{2}{1}[Value][category]), 
    tbl2 = func_r(tables_list{1}{1}[Value][category]), 

   
    list1 = tbl1[index], 
    list2 = tbl2[index], 
  
 
    kol_a = Text.Combine({"index_",id{1}},""),
    kol_b = Text.Combine({"index_",id{0}},""),


    table1 = #table({"a","b"},{}), 

   // list_tmp = {99},

    func = (tabela,val1) => let  
          list_tmp= List.Accumulate(list1, tabela , (state,current)=> func1(state,current,val1)) 
    in
    list_tmp,   

    func1 = (tabela,val2,val1) => let              
       res = Table.InsertRows(tabela,0,{[a = val2 ,b = val1]})               
    in
   res,    



   result1 = List.Accumulate(list2, table1, (state,current)=> func(state,current)),
   result2 = Table.RenameColumns(Table.ReverseRows(result1),{{"a",Text.From(kol_a)} ,{"b",Text.From(kol_b)}}),
   result =Table.AddIndexColumn(result2, "index_values", 0, 1)
in
  result;

GetTable = (tbl, idx_name as text) as table =>
let

        table_od_dim = Record.ToTable(tbl),
        list_od_dim_col_names = Table.ColumnNames(Table.FromRecords(table_od_dim[Value])),
        new_index_name=Text.Combine({"index_",idx_name},""),
        new_label_name=Text.From(idx_name),
        table_dim_res= Table.ExpandRecordColumn(table_od_dim,"Value", list_od_dim_col_names),
        transposed_table = Table.Transpose(table_dim_res),
        headers_table = Table.PromoteHeaders(transposed_table, [PromoteAllScalars=true]),
        rename_columns_table  = Table.RenameColumns(headers_table,{{"index", new_index_name },{"label", new_label_name}})
 
    in
    rename_columns_table;


GetTableValues = (tbl, name as text) as table =>
let
	  
        values_table = Record.ToTable(tbl),
        rename_columns_table  = Table.RenameColumns(values_table,{"Name", "index_values" }),
        result = Table.TransformColumnTypes(rename_columns_table,{{"Value", type number}})

    in
    result;
   


Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        navigationTable = Value.ReplaceType(table, newTableType)
    in
        navigationTable;

               



// Data Source Kind description
Eurostat_API = [
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        Implicit = []
    ],
    Label = Extension.LoadString("DataSourceLabel")
];

// Data Source UI publishing description
Eurostat_API.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = Eurostat_API.Icons,
    SourceTypeImage = Eurostat_API.Icons
];

Eurostat_API.Icons = [
    Icon16 = { Extension.Contents("Eurostat_API16.png"), Extension.Contents("Eurostat_API20.png"), Extension.Contents("Eurostat_API24.png"), Extension.Contents("Eurostat_API32.png") },
    Icon32 = { Extension.Contents("Eurostat_API32.png"), Extension.Contents("Eurostat_API40.png"), Extension.Contents("Eurostat_API48.png"), Extension.Contents("Eurostat_API64.png") }
];
