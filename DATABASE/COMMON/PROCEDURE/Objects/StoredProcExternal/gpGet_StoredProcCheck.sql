-- Function: gpGet_StoredProcCheck()

DROP FUNCTION IF EXISTS gpGet_StoredProcCheck (TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_StoredProcCheck(
    IN inStoredProc   TVarChar , -- Название процедуры
    IN inParam1       TVarChar , -- Название параметра
    IN inValue1       TVarChar , -- Параметр
    IN inParam2       TVarChar , -- Название параметра
    IN inValue2       TVarChar , -- Параметр
    IN inParam3       TVarChar , -- Название параметра
    IN inValue3       TVarChar , -- Параметр
    IN inParam4       TVarChar , -- Название параметра
    IN inValue4       TVarChar , -- Параметр
    IN inParam5       TVarChar , -- Название параметра
    IN inValue5       TVarChar , -- Параметр
    IN inParam6       TVarChar , -- Название параметра
    IN inValue6       TVarChar , -- Параметр
    IN inParam7       TVarChar , -- Название параметра
    IN inValue7       TVarChar , -- Параметр
    IN inParam8       TVarChar , -- Название параметра
    IN inValue8       TVarChar , -- Параметр
    IN inParam9       TVarChar , -- Название параметра
    IN inValue9       TVarChar , -- Параметр
    IN inParam10      TVarChar , -- Название параметра
    IN inValue10      TVarChar , -- Параметр
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS BOOLEAN
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbStartDate TDateTime;
  DECLARE vbEndDate   TDateTime;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpGetUserBySession (inSession);
      
      -- RAISE EXCEPTION 'Ошибка.<%> %', inParam1, inParam2;
      -- RETURN FALSE;
      
      vbStartDate:= CASE WHEN inParam1  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue1)
                         WHEN inParam2  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue2)
                         WHEN inParam3  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue3)
                         WHEN inParam4  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue4)
                         WHEN inParam5  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue5)
                         WHEN inParam6  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue6)
                         WHEN inParam7  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue7)
                         WHEN inParam8  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue8)
                         WHEN inParam9  ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue9)
                         WHEN inParam10 ILIKE '%StartDate%' THEN zfConvert_StringToDate (inValue10)
                    END;
      vbEndDate  := CASE WHEN inParam1  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue1)
                         WHEN inParam2  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue2)
                         WHEN inParam3  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue3)
                         WHEN inParam4  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue4)
                         WHEN inParam5  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue5)
                         WHEN inParam6  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue6)
                         WHEN inParam7  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue7)
                         WHEN inParam8  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue8)
                         WHEN inParam9  ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue9)
                         WHEN inParam10 ILIKE '%EndDate%' THEN zfConvert_StringToDate (inValue10)
                    END;

      IF vbEndDate < CURRENT_DATE
         AND vbStartDate <= (CASE WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 15
                                  -- последний день предыдущего месяца
                                  THEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
 
                                  WHEN EXTRACT (DAY FROM CURRENT_DATE) >= 7
                                  -- первый день предыдущего месяца
                                  THEN DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY')
                                  
                                  -- последний день ДВА месяца назад
                                  ELSE DATE_TRUNC ('MONTH', DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY') -INTERVAL '1 DAY'
                             END)
      THEN 
           RETURN TRUE;
      ELSE 
           RETURN FALSE;
      END IF;
                                 

      
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
  26.08.23                                       *
  18.08.23                                                      *
*/

-- тест
-- 
-- SELECT * FROM gpGet_StoredProcCheck (inStoredProc := 'gpSelect_Movement_Income', inParam1 := 'inStartDate', inValue1 := '25.07.2023', inParam2 := 'inEndDate', inValue2 := '25.07.2023', inParam3 := 'inIsErased', inValue3 := 'False', inParam4 := 'inJuridicalBasisId', inValue4 := '9399', inParam5 := '', inValue5 := '', inParam6 := '', inValue6 := '', inParam7 := '', inValue7 := '', inParam8 := '', inValue8 := '', inParam9 := '', inValue9 := '', inParam10 := '', inValue10 := '', inSession:= zfCalc_UserAdmin())
