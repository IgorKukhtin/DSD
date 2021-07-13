-- Function: gpUpdate_Object_Program_TestRewrite()

DROP FUNCTION IF EXISTS gpUpdate_Object_Program_TestRewrite(TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Program_TestRewrite(
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
DECLARE 
  vbId integer;
  vbIdTest integer;
BEGIN
   
   SELECT Object.Id INTO vbId 
   FROM Object 
   WHERE DescId = zc_Object_Program() AND ValueData = 'FarmacyCash.exe';

   SELECT Object.Id INTO vbIdTest 
   FROM Object 
   WHERE DescId = zc_Object_Program() AND ValueData = 'FarmacyCash_Test.exe';
   
   IF COALESCE (vbId, 0) <> 0 AND COALESCE (vbIdTest, 0) <> 0
   THEN
     --raise notice 'Value: % %', vbId, vbIdTest;
      
     PERFORM lpInsertUpdate_ObjectBLOB(zc_ObjectBlob_Program_Data(), vbIdTest, ObjectBLOB.ValueData)
     FROM ObjectBLOB
     WHERE ObjectBLOB.ObjectId = vbId
       AND ObjectBLOB.DescId = zc_ObjectBlob_Program_Data();
   
   END IF;
 
   SELECT Object.Id INTO vbId 
   FROM Object 
   WHERE DescId = zc_Object_Program() AND ValueData = 'FarmacyCashServise.exe';

   SELECT Object.Id INTO vbIdTest 
   FROM Object 
   WHERE DescId = zc_Object_Program() AND ValueData = 'FarmacyCashServise_Test.exe';
   
   IF COALESCE (vbId, 0) <> 0 AND COALESCE (vbIdTest, 0) <> 0
   THEN

     --raise notice 'Value: % %', vbId, vbIdTest;

     PERFORM lpInsertUpdate_ObjectBLOB(zc_ObjectBlob_Program_Data(), vbIdTest, ObjectBLOB.ValueData)
     FROM ObjectBLOB
     WHERE ObjectBLOB.ObjectId = vbId
       AND ObjectBLOB.DescId = zc_ObjectBlob_Program_Data();
   
   END IF;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                        
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.13                          *

*/
    

select * from gpUpdate_Object_Program_TestRewrite( inSession := '3');