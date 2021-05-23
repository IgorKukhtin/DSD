-- Function: gpGet_Object_Form()

-- DROP FUNCTION gpGet_Object_Form();

CREATE OR REPLACE FUNCTION gpGet_Object_Form(
    IN inFormName    TVarChar,      -- Форма 
    IN inSession     TVarChar       -- текущий пользователь
)
RETURNS TBlob
AS
$BODY$
   DECLARE vbData   TBlob;
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   -- Временно так
   IF vbUserId IN (81245 -- Кирпичева О.А.
                  )
      AND (inFormName ILIKE 'Плановая Прибыль'
        OR inFormName ILIKE 'Плановая Прибыль (Факт)'
        OR inFormName ILIKE 'Плановая Прибыль (Факт себестоимость и расходы и прайс)'
        OR inFormName ILIKE 'Плановая Прибыль (Факт себестоимость и расходы) по дате покуп'
        OR inFormName ILIKE 'Плановая Прибыль (чистая прибыль)'
--      OR inFormName ILIKE 'Плановая Прибыль (цена себестоимость и расходы)'
        OR inFormName ILIKE 'Плановая Прибыль (сравнение цен)'
--      OR inFormName ILIKE 'Плановая Прибыль (сравнение цен себестоимости)'
        OR inFormName ILIKE 'Плановая Прибыль (Факт себестоимость и расходы и прайс)'
          )
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав формировать Отчет <%>.', inFormName;
   END IF;


   SELECT 
         ObjectBLOB_FormData.ValueData
         INTO vbData
   FROM Object
        JOIN ObjectBLOB AS ObjectBLOB_FormData 
                        ON ObjectBLOB_FormData.ObjectId = Object.Id
                       AND ObjectBLOB_FormData.DescId   = zc_ObjectBlob_Form_Data() 
   WHERE Object.ValueData = inFormName
     AND Object.DescId = zc_Object_Form()
    ;
    
   RETURN vbData; 
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.21                                        *
*/

-- тест
-- SELECT LENGTH (gpGet_Object_Form), gpGet_Object_Form AS FormValue  FROM gpGet_Object_Form('Плановая Прибыль (Факт)', '81245')
