-- Function: public.gpinsertupdate_logbillsks2(tblob, tvarchar)

DROP FUNCTION if exists public.gpinsertupdate_logbillsks2(tblob, tvarchar);

CREATE OR REPLACE FUNCTION public.gpinsertupdate_logbillsks2(
    inxmlfile tblob,
    insession tvarchar)
  RETURNS void AS
$BODY$
  DECLARE x TEXT;
  DECLARE xmlBillDate TDateTime;
  DECLARE r RECORD;
  DECLARE vbMovementId integer;
  DECLARE vbUserId Integer; 
BEGIN

  vbUserId:= lpGetUserBySession (inSession);
 --RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
  -- Убираем экранизацию
  SELECT INTO x inXMLFile;
  SELECT INTO x REPLACE(x, 'Windows-1251', 'UTF-8');
  SELECT INTO x REPLACE(x, '%', '<');
  SELECT INTO x REPLACE(x, '$', '>');
  SELECT INTO x REPLACE(x, '^', '"');
  
  -- Дата счета
    SELECT INTO xmlBillDate unnest(xpath('//Array-Bill/bill[1]/od/text()', x::XML));
 
  -- Вставка файла
  INSERT INTO logBillsKS(BillDate, XMLData) VALUES (xmlBillDate::TDateTime, x::TBlob);

  -- *** Временная таблица сотрудников для кеша
  --  CREATE TEMP TABLE _tmpEmployees (ID integer, Name TVarchar) ON COMMIT DROP;
  --  INSERT INTO _tmpEmployees (ID, Name)
  --	    SELECT ID, Name FROM gpSelect_Object_Personal(TRUE, inSession);
 
 -- заполнение документа

  -- *** Парсим XML в таблицу
    CREATE TEMP TABLE _tmpReportMobileKS (MobilePhone TVarchar, TotalSum tfloat) ON COMMIT DROP;
    INSERT INTO _tmpReportMobileKS (MobilePhone, TotalSum)
    WITH x AS (
      SELECT xmldata::XML AS T FROM logBillsKS l WHERE l.BillDate = xmlBillDate
    )
    SELECT
    -- Номер мобильного
       regexp_split_to_table(replace(replace(CAST(xpath('//Array-Bill/bill/subs[stnd_id=1]/msisdn/text()', T) AS TEXT), '}', ''), '{', ''), ',')::TVarchar AS MobilePhone
    -- Итого
      ,regexp_split_to_table(replace(replace(CAST(xpath('//Array-Bill/bill/subs[stnd_id=1]/s_det/tot/text()', T) AS TEXT), '}', ''), '{', ''),',')::tfloat AS TotalSum
   
    FROM x;

--//////////////
 -- новые моб.номера
    CREATE TEMP TABLE _tmpMobile (Id integer, MobileNum TVarchar) ON COMMIT DROP;
    INSERT INTO _tmpMobile (Id, MobileNum)
	   SELECT Object_MobileEmployee.Id, Object_MobileEmployee.ValueData   AS MobileNum
           FROM Object AS Object_MobileEmployee
           WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
             AND Object_MobileEmployee.isErased = False;
             

 FOR r IN (SELECT tmp.MobilePhone, tmp.TotalSum FROM _tmpReportMobileKS tmp)
    LOOP
  -- RAISE EXCEPTION 'Ошибка.%', r.MobilePhone;
    IF NOT EXISTS (SELECT _tmpMobile.Id FROM _tmpMobile WHERE RIGHT(_tmpMobile.MobileNum, 10) = r.MobilePhone)
    THEN
       PERFORM lpInsertUpdate_Object_MobileEmployee2(ioId             := 0
                                                   , inCode           := 0
                                                   , inName           := r.MobilePhone
                                                   , inLimit          := 0 ::tfloat
                                                   , inDutyLimit      := 0 ::tfloat
                                                   , inNavigator      := 0 ::tfloat
                                                   , inComment        := '(авто)'
                                                   , inPersonalId     := 0
                                                   , inMobileTariffId := 0
                                                   , inUserId         := vbUserId
                                                 );
    END IF;
    END LOOP;
   
--/////////////


  -- *** врем. табл. телефонов и тарифов
    CREATE TEMP TABLE _tmpMobileEmployeeTariff (Id integer, PersonalId integer, TariffId integer, MobileNum TVarchar, MobileLimit Tfloat, DutyLimit Tfloat, Navigator Tfloat, Monthly Tfloat) ON COMMIT DROP;
    INSERT INTO _tmpMobileEmployeeTariff (Id, PersonalId, TariffId, MobileNum, MobileLimit, DutyLimit, Navigator, Monthly)
	    SELECT Object_MobileEmployee.Id          AS Id
                 , COALESCE(ObjectLink_MobileEmployee_Personal.ChildObjectId, 0) ::Integer      AS PersonalId
                 , COALESCE(ObjectLink_MobileEmployee_MobileTariff.ChildObjectId, 0) ::Integer  AS TariffId
                 , COALESCE(Object_MobileEmployee.ValueData, 0) ::TFloat   AS MobileNum
                 , COALESCE(ObjectFloat_Limit.ValueData, 0) ::TFloat       AS MobileLimit
                 , COALESCE(ObjectFloat_DutyLimit.ValueData, 0) ::TFloat   AS DutyLimit
                 , COALESCE(ObjectFloat_Navigator.ValueData, 0) ::TFloat   AS Navigator
                 , COALESCE(ObjectFloat_Monthly.ValueData, 0) ::TFloat     AS Monthly
            FROM Object AS Object_MobileEmployee
               LEFT JOIN ObjectFloat AS ObjectFloat_Limit
                                  ON ObjectFloat_Limit.ObjectId = Object_MobileEmployee.Id 
                                 AND ObjectFloat_Limit.DescId = zc_ObjectFloat_MobileEmployee_Limit()
               LEFT JOIN ObjectFloat AS ObjectFloat_DutyLimit
                                     ON ObjectFloat_DutyLimit.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjectFloat_DutyLimit.DescId = zc_ObjectFloat_MobileEmployee_DutyLimit()
               LEFT JOIN ObjectFloat AS ObjectFloat_Navigator
                                     ON ObjectFloat_Navigator.ObjectId = Object_MobileEmployee.Id 
                                    AND ObjectFloat_Navigator.DescId = zc_ObjectFloat_MobileEmployee_Navigator()
               LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_Personal
                                    ON ObjectLink_MobileEmployee_Personal.ObjectId = Object_MobileEmployee.Id 
                                   AND ObjectLink_MobileEmployee_Personal.DescId = zc_ObjectLink_MobileEmployee_Personal()
               LEFT JOIN ObjectLink AS ObjectLink_MobileEmployee_MobileTariff
                                    ON ObjectLink_MobileEmployee_MobileTariff.ObjectId = Object_MobileEmployee.Id 
                                   AND ObjectLink_MobileEmployee_MobileTariff.DescId = zc_ObjectLink_MobileEmployee_MobileTariff()
               LEFT JOIN ObjectFloat AS ObjectFloat_Monthly
                                     ON ObjectFloat_Monthly.ObjectId = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId
                                    AND ObjectFloat_Monthly.DescId = zc_ObjectFloat_MobileTariff_Monthly()
            WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
              AND Object_MobileEmployee.isErased = False;


  -- создание документа
  vbMovementId := (SELECT Movement.Id 
                   FROM Movement
                   WHERE Movement.OperDate = xmlBillDate ::tdatetime
                     AND Movement.DescId = zc_Movement_MobileBills()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                   );
              
  IF COALESCE (vbMovementId, 0) = 0 THEN 
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_MobileBills(), CAST (NEXTVAL ('Movement_MobileBills_seq') AS TVarChar), xmlBillDate ::tdatetime, NULL);
  END IF;


  -- *** Заполняем таблицу журнала счетов
    FOR r IN (SELECT tmp.MobilePhone, tmp.TotalSum FROM _tmpReportMobileKS tmp)
    LOOP
  
      PERFORM lpInsertUpdate_MovementItem_MobileBills(
      -- Указываем, что мы заливаем инфу с файла
        ioID := 0 ::INTEGER  ---1::INTEGER

      -- ид документа
        , inMovementId := vbMovementId
      -- номер телефона
        , inMobileEmployeeId := (SELECT _tmpMobileEmployeeTariff.Id
                           FROM _tmpMobileEmployeeTariff
                           WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone)::INTEGER
      -- Сумма итого
        , inAmount := r.TotalSum ::tfloat
      -- Абонплата
	, inCurrMonthly := (SELECT Coalesce(_tmpMobileEmployeeTariff.Monthly,0)
                            FROM _tmpMobileEmployeeTariff
                            WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone):: tfloat
      -- Навигатор
	, inCurrNavigator := (SELECT _tmpMobileEmployeeTariff.Navigator
                              FROM _tmpMobileEmployeeTariff
                              WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone):: tfloat
      -- 
        , inPrevNavigator := 0 :: tfloat 
        , inLimit := (SELECT _tmpMobileEmployeeTariff.MobileLimit
                      FROM _tmpMobileEmployeeTariff
                      WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone):: tfloat
        , inPrevLimit := 0 :: tfloat
    -- Служебный лимит
        , inDutyLimit := (SELECT _tmpMobileEmployeeTariff.DutyLimit
                      FROM _tmpMobileEmployeeTariff
                      WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone):: tfloat
      -- Перелимит
        , inOverlimit := (SELECT CASE WHEN (r.TotalSum - (_tmpMobileEmployeeTariff.MobileLimit +_tmpMobileEmployeeTariff.DutyLimit)) > 0 
                                      THEN (r.TotalSum - (_tmpMobileEmployeeTariff.MobileLimit +_tmpMobileEmployeeTariff.DutyLimit))
                                      ELSE 0
                                 END
                          FROM _tmpMobileEmployeeTariff
                          WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone):: tfloat
        , inPrevMonthly := 0 :: tfloat
      -- Регион
        , inRegionId := 0
      -- ИД сотрудника                
	, inEmployeeID := (SELECT _tmpMobileEmployeeTariff.PersonalId
                           FROM _tmpMobileEmployeeTariff
                           WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone)::INTEGER
        , inPrevEmployeeId := 0
      -- ИД тарифа
        , inMobileTariffID := (SELECT _tmpMobileEmployeeTariff.TariffId
                               FROM _tmpMobileEmployeeTariff
                               WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = r.MobilePhone)::INTEGER
        , inPrevMobileTariffId := 0
        , inUserId := vbUserId

        );
        --RAISE EXCEPTION 'Ошибка.%', vbMovementId;
    END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 30.09.16         *
*/

-- тест
-- 