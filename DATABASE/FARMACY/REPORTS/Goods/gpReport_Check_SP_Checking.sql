-- Function: gpReport_Check_SP_Checking()

DROP FUNCTION IF EXISTS gpReport_Check_SP_Checking(Text, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_SP_Checking(
    IN inFileJson        Text      , -- json Файл    
    IN inDataJson        Text      , -- json Данные    
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (NumLine                  INTEGER, 
               InvNumber_Full           TVarChar,
               UnitName                 TVarChar,
               JuridicalName            TVarChar,
               OperDate                 TDateTime,

               InvNumberSP              TVarChar,
               SummaSP_pack             TFloat,
               SummaSP			        TFloat,
               SummaSP_pack_File        TFloat,
               SummaSP_File			    TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF inFileJson = '[]'
  THEN
    RAISE EXCEPTION 'Данные с файла не загружены.';
  END IF;
      
  IF inDataJson = '[]'
  THEN
    RAISE EXCEPTION 'Данные с базы не загружены.';
  END IF;

  
  -- из JSON в таблицу
  CREATE TEMP TABLE tblFileDataJSON
  (
     InvNumberSP              TVarChar,
     SummaSP_pack             TFloat,
     SummaSP			      TFloat
  ) ON COMMIT DROP;

  INSERT INTO tblFileDataJSON
  SELECT *
  FROM json_populate_recordset(null::tblFileDataJSON, replace(replace(replace(inFileJson, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
  -- из JSON в таблицу
  CREATE TEMP TABLE tblDataJSON
  (
     InvNumber_Full           TVarChar,
     UnitName                 TVarChar,
     JuridicalName            TVarChar,
     OperDate                 TDateTime,

     InvNumberSP              TVarChar,
     SummaSP_pack             TFloat,
     SummaSP			      TFloat
  ) ON COMMIT DROP;

  INSERT INTO tblDataJSON
  SELECT *
  FROM json_populate_recordset(null::tblDataJSON, replace(replace(replace(inDataJson, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);

  -- Результат
  RETURN QUERY
  SELECT (ROW_NUMBER() OVER (ORDER BY DataJSON.OperDate))::Integer AS NumLine
       , DataJSON.InvNumber_Full
       , DataJSON.UnitName
       , DataJSON.JuridicalName
       , DataJSON.OperDate

       , COALESCE(DataJSON.InvNumberSP, FileDataJSON.InvNumberSP)
       , DataJSON.SummaSP_pack
       , DataJSON.SummaSP	
       , FileDataJSON.SummaSP_pack
       , FileDataJSON.SummaSP	
  
  FROM tblDataJSON AS DataJSON  
  
       FULL JOIN (SELECT * FROM tblFileDataJSON WHERE COALESCE(tblFileDataJSON.InvNumberSP, '')  <> '') AS FileDataJSON
                                 ON FileDataJSON.InvNumberSP = DataJSON.InvNumberSP
                                 
  WHERE COALESCE (DataJSON.SummaSP_pack, 0) <> COALESCE (FileDataJSON.SummaSP_pack, 0)
     OR COALESCE (DataJSON.SummaSP, 0) <> COALESCE (FileDataJSON.SummaSP, 0)
  ORDER BY DataJSON.OperDate
  ;
   
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 29.07.21                                                                    *
*/

-- тест 

select * from gpReport_Check_SP_Checking(inFileJson := '[{"invnumbersp":"0000-T1PA-T5PA-79K8","summasp_pack":121.82,"summasp":121.82},{"invnumbersp":"0000-782P-MH70-2E09","summasp_pack":60.91,"summasp":60.91},{"invnumbersp":"0000-9800-3K6A-9PH5","summasp_pack":29.46,"summasp":29.46},{"invnumbersp":"0000-2TA5-A645-HXMT","summasp_pack":16.24,"summasp":16.24},{"invnumbersp":"0000-X979-97M6-TM7E","summasp_pack":35.77,"summasp":35.77},{"invnumbersp":"0000-6197-3M64-P488","summasp_pack":133.24,"summasp":133.24},{"invnumbersp":"0000-0756-KHX7-2799","summasp_pack":66.62,"summasp":66.62},{"invnumbersp":"0000-51HK-1XM4-E195","summasp_pack":130.64,"summasp":130.64},{"invnumbersp":"0000-40P3-7842-K729","summasp_pack":28.21,"summasp":28.21},{"invnumbersp":"0000-3MAK-6140-3P46","summasp_pack":15.12,"summasp":15.12},{"invnumbersp":"0000-A723-H137-87K8","summasp_pack":29.46,"summasp":29.46},{"invnumbersp":"0000-087H-3461-9XTM","summasp_pack":32.66,"summasp":32.66},{"invnumbersp":"0000-E23P-622T-08X6","summasp_pack":35.77,"summasp":35.77},{"invnumbersp":"0000-879E-7639-HHX3","summasp_pack":15.12,"summasp":15.12},{"invnumbersp":"0000-0X3K-H3HT-P92X","summasp_pack":66.62,"summasp":66.62},{"invnumbersp":"0000-56P6-50TX-252K","summasp_pack":9.12,"summasp":9.12},{"invnumbersp":"0000-1EXK-1MAE-9KXA","summasp_pack":9.12,"summasp":9.12},{"invnumbersp":"0000-K0E3-36HT-EMT3","summasp_pack":17.05,"summasp":17.05},{"invnumbersp":"0000-91AX-0EPX-47K8","summasp_pack":71.55,"summasp":71.2},{"invnumbersp":"0000-683K-1173-PE0A","summasp_pack":29.46,"summasp":29.46},{"invnumbersp":"0000-A3K0-5753-1937","summasp_pack":32.49,"summasp":32.49},{"invnumbersp":"0000-06AT-9KK3-8571","summasp_pack":18.25,"summasp":18.25},{"invnumbersp":"0000-9P19-H7ET-3188","summasp_pack":71.54,"summasp":71.54},{"invnumbersp":"0000-92PE-K9KE-P3M6","summasp_pack":36.48,"summasp":36.48},{"invnumbersp":"0000-HE3X-06PX-05T5","summasp_pack":58.92,"summasp":58.92},{"invnumbersp":"0000-8P49-T8EA-T521","summasp_pack":58.92,"summasp":58.92},{"invnumbersp":"0000-3X9P-XM62-T9P9","summasp_pack":34.11,"summasp":34.11},{"invnumbersp":"0000-XXM3-P3PX-3459","summasp_pack":71.55,"summasp":71.55},{"invnumbersp":"0000-M71P-KH52-AH38","summasp_pack":29.46,"summasp":29.46},{"invnumbersp":"0000-T68P-16M3-0TAX","summasp_pack":36.5,"summasp":36.5},{"invnumbersp":"0000-08A0-0281-3T1E","summasp_pack":15.12,"summasp":15.12},{"invnumbersp":"0000-40T1-M5EP-K7H3","summasp_pack":17.04,"summasp":17.04},{"invnumbersp":"0000-T2X0-39PK-A73X","summasp_pack":16.75,"summasp":16.75},{"invnumbersp":"0000-5H91-8PHT-3XPA","summasp_pack":65.32,"summasp":65},{"invnumbersp":"0000-1T14-94EK-3A49","summasp_pack":66.62,"summasp":66.62},{"invnumbersp":"0000-76H9-KX88-5XH7","summasp_pack":9.12,"summasp":9.12},{"invnumbersp":"0000-3KAX-5AA6-623E","summasp_pack":65.32,"summasp":65.32},{"invnumbersp":"0000-HK31-23AX-X460","summasp_pack":35.77,"summasp":35.77},{"invnumbersp":"0000-E38M-T2X6-1K0P","summasp_pack":71.55,"summasp":71.55},{"invnumbersp":"0000-8TP8-0MKE-1MT1","summasp_pack":16.75,"summasp":16.75},{"invnumbersp":"0000-79P3-1X6M-AHTT","summasp_pack":7.56,"summasp":7.56},{"invnumbersp":"0000-MX12-0KH6-705P","summasp_pack":17.04,"summasp":17.04},{"invnumbersp":"0000-4K0T-MHEE-2TP4","summasp_pack":37.11,"summasp":37.11},{"invnumbersp":"0000-PX27-HM9E-X0P4","summasp_pack":37.11,"summasp":37.11},{"invnumbersp":"0000-ET89-MM53-02PP","summasp_pack":18.24,"summasp":18.24},{"invnumbersp":"0000-31X1-H830-H63K","summasp_pack":143.1,"summasp":142.4},{"invnumbersp":"","summasp_pack":null,"summasp":null},{"invnumbersp":"","summasp_pack":2041.7,"summasp":2040.33}]' , inDataJson := '[{"invnumber_full":"№ 16 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-3MAK-6140-3P46","summasp_pack":15.12,"summasp":15.12},{"invnumber_full":"№ 49 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-879E-7639-HHX3","summasp_pack":15.12,"summasp":15.12},{"invnumber_full":"№ 87 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-08A0-0281-3T1E","summasp_pack":15.12,"summasp":15.12},{"invnumber_full":"№ 106 от 2022-03-30","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-30 00:00:00.000","invnumbersp":"0000-79P3-1X6M-AHTT","summasp_pack":7.56,"summasp":7.56},{"invnumber_full":"№ 89 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-T2X0-39PK-A73X","summasp_pack":16.75,"summasp":16.75},{"invnumber_full":"№ 90 от 2022-03-30","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-30 00:00:00.000","invnumbersp":"0000-8TP8-0MKE-1MT1","summasp_pack":16.75,"summasp":16.75},{"invnumber_full":"№ 67 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-56P6-50TX-252K","summasp_pack":9.12,"summasp":9.12},{"invnumber_full":"№ 4536 от 2022-03-23","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-23 00:00:00.000","invnumbersp":"0000-1EXK-1MAE-9KXA","summasp_pack":9.12,"summasp":9.12},{"invnumber_full":"№ 4666 от 2022-03-24","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-24 00:00:00.000","invnumbersp":"0000-06AT-9KK3-8571","summasp_pack":18.25,"summasp":18.25},{"invnumber_full":"№ 3 от 2022-03-25","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-25 00:00:00.000","invnumbersp":"0000-92PE-K9KE-P3M6","summasp_pack":36.48,"summasp":36.48},{"invnumber_full":"№ 86 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-T68P-16M3-0TAX","summasp_pack":36.5,"summasp":36.5},{"invnumber_full":"№ 5 от 2022-03-28","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-28 00:00:00.000","invnumbersp":"0000-76H9-KX88-5XH7","summasp_pack":9.12,"summasp":9.12},{"invnumber_full":"№ 58 от 2022-03-31","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-31 00:00:00.000","invnumbersp":"0000-ET89-MM53-02PP","summasp_pack":18.24,"summasp":18.24},{"invnumber_full":"№ 108 от 2022-03-30","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-30 00:00:00.000","invnumbersp":"0000-4K0T-MHEE-2TP4","summasp_pack":37.11,"summasp":37.11},{"invnumber_full":"№ 4435 от 2022-03-30","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-30 00:00:00.000","invnumbersp":"0000-PX27-HM9E-X0P4","summasp_pack":37.11,"summasp":37.11},{"invnumber_full":"№ 4570 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-6197-3M64-P488","summasp_pack":133.24,"summasp":133.24},{"invnumber_full":"№ 4603 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-0756-KHX7-2799","summasp_pack":66.62,"summasp":66.62},{"invnumber_full":"№ 66 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-0X3K-H3HT-P92X","summasp_pack":66.62,"summasp":66.62},{"invnumber_full":"№ 105 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-1T14-94EK-3A49","summasp_pack":66.62,"summasp":66.62},{"invnumber_full":"№ 4662 от 2022-03-24","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-24 00:00:00.000","invnumbersp":"0000-K0E3-36HT-EMT3","summasp_pack":17.05,"summasp":17.05},{"invnumber_full":"№ 83 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-3X9P-XM62-T9P9","summasp_pack":34.11,"summasp":34.11},{"invnumber_full":"№ 88 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-40T1-M5EP-K7H3","summasp_pack":17.04,"summasp":17.04},{"invnumber_full":"№ 107 от 2022-03-30","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-30 00:00:00.000","invnumbersp":"0000-MX12-0KH6-705P","summasp_pack":17.04,"summasp":17.04},{"invnumber_full":"№ 4536 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-2TA5-A645-HXMT","summasp_pack":16.24,"summasp":16.24},{"invnumber_full":"№ 4665 от 2022-03-24","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-24 00:00:00.000","invnumbersp":"0000-A3K0-5753-1937","summasp_pack":32.49,"summasp":32.49},{"invnumber_full":"№ 4535 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-9800-3K6A-9PH5","summasp_pack":29.46,"summasp":29.46},{"invnumber_full":"№ 17 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-A723-H137-87K8","summasp_pack":29.46,"summasp":29.46},{"invnumber_full":"№ 4664 от 2022-03-24","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-24 00:00:00.000","invnumbersp":"0000-683K-1173-PE0A","summasp_pack":29.46,"summasp":29.46},{"invnumber_full":"№ 4 от 2022-03-25","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-25 00:00:00.000","invnumbersp":"0000-HE3X-06PX-05T5","summasp_pack":58.92,"summasp":58.92},{"invnumber_full":"№ 5 от 2022-03-25","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-25 00:00:00.000","invnumbersp":"0000-8P49-T8EA-T521","summasp_pack":58.92,"summasp":58.92},{"invnumber_full":"№ 85 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-M71P-KH52-AH38","summasp_pack":29.46,"summasp":29.46},{"invnumber_full":"№ 4500 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-T1PA-T5PA-79K8","summasp_pack":121.82,"summasp":121.82},{"invnumber_full":"№ 4534 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-782P-MH70-2E09","summasp_pack":60.91,"summasp":60.91},{"invnumber_full":"№ 4604 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-51HK-1XM4-E195","summasp_pack":130.64,"summasp":130.64},{"invnumber_full":"№ 47 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-087H-3461-9XTM","summasp_pack":32.66,"summasp":32.66},{"invnumber_full":"№ 104 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-5H91-8PHT-3XPA","summasp_pack":65.32,"summasp":65},{"invnumber_full":"№ 17 от 2022-03-29","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-29 00:00:00.000","invnumbersp":"0000-3KAX-5AA6-623E","summasp_pack":65.32,"summasp":65.32},{"invnumber_full":"№ 4537 от 2022-03-21","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-21 00:00:00.000","invnumbersp":"0000-X979-97M6-TM7E","summasp_pack":35.77,"summasp":35.77},{"invnumber_full":"№ 48 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-E23P-622T-08X6","summasp_pack":35.77,"summasp":35.77},{"invnumber_full":"№ 4663 от 2022-03-24","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-24 00:00:00.000","invnumbersp":"0000-91AX-0EPX-47K8","summasp_pack":71.55,"summasp":71.2},{"invnumber_full":"№ 2 от 2022-03-25","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-25 00:00:00.000","invnumbersp":"0000-9P19-H7ET-3188","summasp_pack":71.54,"summasp":71.54},{"invnumber_full":"№ 84 от 2022-03-26","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-26 00:00:00.000","invnumbersp":"0000-XXM3-P3PX-3459","summasp_pack":71.55,"summasp":71.55},{"invnumber_full":"№ 44 от 2022-03-29","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-29 00:00:00.000","invnumbersp":"0000-HK31-23AX-X460","summasp_pack":35.77,"summasp":35.77},{"invnumber_full":"№ 89 от 2022-03-30","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-30 00:00:00.000","invnumbersp":"0000-E38M-T2X6-1K0P","summasp_pack":71.55,"summasp":71.55},{"invnumber_full":"№ 59 от 2022-03-31","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-31 00:00:00.000","invnumbersp":"0000-31X1-H830-H63K","summasp_pack":143.1,"summasp":142.4},{"invnumber_full":"№ 15 от 2022-03-22","unitname":"Аптека 1 ж.м. Тополя-2, 28","juridicalname":"ТОВ Фарлен","operdate":"2022-03-22 00:00:00.000","invnumbersp":"0000-40P3-7842-K729","summasp_pack":28.21,"summasp":28.21}]' ,  inSession := '3');


