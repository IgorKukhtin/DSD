-- Function: lpGet_Object_MobileConst

DROP FUNCTION IF EXISTS lpGet_Object_MobileConst (Integer);

CREATE OR REPLACE FUNCTION lpGet_Object_MobileConst (
    IN inId Integer
)
RETURNS TABLE (Id                Integer  
             , Code              Integer
             , Name              TVarChar 
             , MobileVersion     TVarChar  -- Версия мобильного приложения. Пример: "1.0.3.625"
             , MobileAPKFileName TVarChar  -- Название ".apk" файла мобильного приложения
             , OperDateDiff      Integer   -- На сколько дней позже создавать док Возврат и Приход денег
             , ReturnDayCount    Integer   -- Сколько дней принимаются возвраты по старым ценам
             , CriticalOverDays  Integer   -- Количество дней просрочки, после которого формирование заявки невозможно
             , CriticalDebtSum   TFloat    -- Сумма долга, после которого формирование заявки невозможно
              )
AS $BODY$
BEGIN
      RETURN QUERY  
        SELECT Object_MobileConst.Id
             , Object_MobileConst.ObjectCode                   AS Code
             , Object_Code.ValueData                           AS Name
             , ObjectString_MobileVersion.ValueData            AS MobileVersion
             , ObjectString_MobileAPKFileName.ValueData        AS MobileAPKFileName
             , ObjectFloat_OperDateDiff.ValueData::Integer     AS OperDateDiff
             , ObjectFloat_ReturnDayCount.ValueData::Integer   AS ReturnDayCount
             , ObjectFloat_CriticalOverDays.ValueData::Integer AS CriticalOverDays
             , ObjectFloat_CriticalDebtSum.ValueData           AS CriticalDebtSum
        FROM Object AS Object_MobileConst
             LEFT JOIN Object AS Object_Code ON Object_Code.Id = Object_MobileConst.ObjectCode
             LEFT JOIN ObjectString AS ObjectString_MobileVersion 
                                    ON ObjectString_MobileVersion.ObjectId = Object_MobileConst.Id
                                   AND ObjectString_MobileVersion.DescId = zc_ObjectString_MobileConst_MobileVersion ()
             LEFT JOIN ObjectString AS ObjectString_MobileAPKFileName
                                    ON ObjectString_MobileAPKFileName.ObjectId = Object_MobileConst.Id
                                   AND ObjectString_MobileAPKFileName.DescId = zc_ObjectString_MobileConst_MobileAPKFileName ()
             LEFT JOIN ObjectFloat AS ObjectFloat_OperDateDiff
                                   ON ObjectFloat_OperDateDiff.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_OperDateDiff.DescId = zc_ObjectFloat_MobileConst_OperDateDiff() 
             LEFT JOIN ObjectFloat AS ObjectFloat_ReturnDayCount
                                   ON ObjectFloat_ReturnDayCount.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_ReturnDayCount.DescId = zc_ObjectFloat_MobileConst_ReturnDayCount() 
             LEFT JOIN ObjectFloat AS ObjectFloat_CriticalOverDays
                                   ON ObjectFloat_CriticalOverDays.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_CriticalOverDays.DescId = zc_ObjectFloat_MobileConst_CriticalOverDays()
             LEFT JOIN ObjectFloat AS ObjectFloat_CriticalDebtSum
                                   ON ObjectFloat_CriticalDebtSum.ObjectId = Object_MobileConst.Id
                                  AND ObjectFloat_CriticalDebtSum.DescId = zc_ObjectFloat_MobileConst_CriticalDebtSum()
        WHERE Object_MobileConst.Id = inId 
          AND Object_MobileConst.DescId = zc_Object_MobileConst()  
        ;
      

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 19.07.17                                                       *
*/

-- тест
-- SELECT * FROM lpGet_Object_MobileConst (inId:= 1005694);
