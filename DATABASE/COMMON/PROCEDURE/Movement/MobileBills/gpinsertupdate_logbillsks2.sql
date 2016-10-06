-- Function: public.gpinsertupdate_logbillsks2(tblob, tvarchar)

DROP FUNCTION if exists public.gpinsertupdate_logbillsks2(tblob, tvarchar);

CREATE OR REPLACE FUNCTION public.gpinsertupdate_logbillsks2(
    inXmlfile       tblob   ,  -- файл xml
    inSession       tvarchar,  -- сессия пользователя
)
  RETURNS void AS
$BODY$
  DECLARE vbXMLFile TEXT;
  DECLARE vbOperDate TDateTime;
  DECLARE vbRecord RECORD;
  DECLARE vbMovementId integer;
  DECLARE vbUserId Integer; 
  DECLARE vbContractId Integer; 

BEGIN

  vbUserId:= lpGetUserBySession (inSession);
 --RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
  -- Убираем экранизацию
  vbXMLFile:= REPLACE (inXMLFile, 'Windows-1251', 'UTF-8');
  vbXMLFile:= REPLACE (vbXMLFile, '%', '<');
  vbXMLFile:= REPLACE (vbXMLFile, '$', '>');
  vbXMLFile:= REPLACE (vbXMLFile, '^', '"');
  
   -- Дата счета
   vbOperDate:= (SELECT unnest(xpath('//Array-Bill/bill[1]/od/text()', vbXMLFile::XML)));
 
   -- *** Парсим XML в таблицу
    CREATE TEMP TABLE _tmpItems (MobilePhone TVarchar, TotalSum tfloat) ON COMMIT DROP;
    INSERT INTO _tmpItems (MobilePhone, TotalSum)
    WITH tmpData AS (
      SELECT vbXMLFile::XML AS ValueData
    )
    SELECT
    -- Номер мобильного
       regexp_split_to_table(replace(replace(CAST(xpath('//Array-Bill/bill/subs[stnd_id=1]/msisdn/text()', ValueData) AS TEXT), '}', ''), '{', ''), ',')::TVarchar AS MobilePhone
    -- Итого
      ,regexp_split_to_table(replace(replace(CAST(xpath('//Array-Bill/bill/subs[stnd_id=1]/s_det/tot/text()', ValueData) AS TEXT), '}', ''), '{', ''),',')::tfloat AS TotalSum
   
    FROM tmpData;

--//////////////
 -- новые моб.номера
    CREATE TEMP TABLE _tmpMobile (Id integer, MobileNum TVarchar) ON COMMIT DROP;
    INSERT INTO _tmpMobile (Id, MobileNum)
	   SELECT Object_MobileEmployee.Id, Object_MobileEmployee.ValueData   AS MobileNum
           FROM Object AS Object_MobileEmployee
           WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
             AND Object_MobileEmployee.isErased = False;
             

 FOR vbRecord IN (SELECT tmp.MobilePhone, tmp.TotalSum FROM _tmpItems tmp)
    LOOP
      IF NOT EXISTS (SELECT _tmpMobile.Id FROM _tmpMobile WHERE RIGHT(_tmpMobile.MobileNum, 10) = vbRecord.MobilePhone)
         THEN
           PERFORM lpInsertUpdate_Object_MobileEmployee2 (ioId             := 0
                                                        , inCode           := 0
                                                        , inName           := vbRecord.MobilePhone
                                                        , inLimit          := 0  ::Tfloat
                                                        , inDutyLimit      := 0  ::Tfloat
                                                        , inNavigator      := 0  ::Tfloat
                                                        , inComment        := '' ::TVarchar
                                                        , inPersonalId     := 0
                                                        , inMobileTariffId := 0
                                                        , inUserId         := vbUserId
                                                         );
    END IF;
    END LOOP;
--/////////////


  -- *** врем. табл. телефонов и тарифов
    CREATE TEMP TABLE _tmpMobileEmployeeTariff (Id integer, PersonalId integer, TariffId integer, MobileNum TVarchar, MobileLimit Tfloat, DutyLimit Tfloat, Navigator Tfloat, Monthly Tfloat, ContractId integer) ON COMMIT DROP;

    INSERT INTO _tmpMobileEmployeeTariff (Id, PersonalId, TariffId, MobileNum, MobileLimit, DutyLimit, Navigator, Monthly, ContractId)
	    SELECT Object_MobileEmployee.Id          AS Id
                 , COALESCE (ObjectLink_MobileEmployee_Personal.ChildObjectId, 0) ::Integer      AS PersonalId
                 , COALESCE (ObjectLink_MobileEmployee_MobileTariff.ChildObjectId, 0) ::Integer  AS TariffId
                 , COALESCE (Object_MobileEmployee.ValueData, '') ::TVarchar    AS MobileNum
                 , COALESCE (ObjectFloat_Limit.ValueData, 0)      ::TFloat      AS MobileLimit
                 , COALESCE (ObjectFloat_DutyLimit.ValueData, 0)  ::TFloat      AS DutyLimit
                 , COALESCE (ObjectFloat_Navigator.ValueData, 0)  ::TFloat      AS Navigator
                 , COALESCE (ObjectFloat_Monthly.ValueData, 0)    ::TFloat      AS Monthly
                 , COALESCE (ObjectLink_MobileTariff_Contract.ChildObjectId, 0) AS ContractId
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

               LEFT JOIN ObjectLink AS ObjectLink_MobileTariff_Contract
                                    ON ObjectLink_MobileTariff_Contract.ObjectId = ObjectLink_MobileEmployee_MobileTariff.ChildObjectId
                                   AND ObjectLink_MobileTariff_Contract.DescId = zc_ObjectLink_MobileTariff_Contract()
       
            WHERE Object_MobileEmployee.DescId = zc_Object_MobileEmployee()
              AND Object_MobileEmployee.isErased = False;

  -- получаем договор 
  vbContractId := (SELECT DISTINCT tmp.ContractId FROM _tmpMobileEmployeeTariff AS tmp WHERE tmp.ContractId <>0 );

  -- создание документа
  vbMovementId := (SELECT Movement.Id 
                   FROM Movement
                       INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                              AND MovementLinkObject_Contract.ObjectId = vbContractId
                   WHERE Movement.OperDate = vbOperDate ::tdatetime
                     AND Movement.DescId = zc_Movement_MobileBills()
                     AND Movement.StatusId = zc_Enum_Status_Complete()
                   );
              
  IF COALESCE (vbMovementId, 0) = 0 THEN 
     vbMovementId := gpInsertUpdate_Movement_MobileBills (0, CAST (NEXTVAL ('Movement_MobileBills_seq') AS TVarChar), vbOperDate ::tdatetime, vbContractId :: Integer, inSession ::TVarChar);
  END IF;


  -- *** Заполняем таблицу журнала счетов
    FOR vbRecord IN (SELECT tmp.MobilePhone, tmp.TotalSum FROM _tmpItems tmp)
    LOOP
  
      PERFORM lpInsertUpdate_MovementItem_MobileBills(
      -- Указываем, что мы заливаем инфу с файла
        ioID := 0 ::INTEGER  ---1::INTEGER

      -- ид документа
        , inMovementId := vbMovementId
      -- номер телефона
        , inMobileEmployeeId := (SELECT _tmpMobileEmployeeTariff.Id
                           FROM _tmpMobileEmployeeTariff
                           WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone)::INTEGER
      -- Сумма итого
        , inAmount := vbRecord.TotalSum ::tfloat
      -- Абонплата
	, inCurrMonthly := (SELECT COALESCE (_tmpMobileEmployeeTariff.Monthly,0)
                            FROM _tmpMobileEmployeeTariff
                            WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone):: tfloat
      -- Навигатор
	, inCurrNavigator := (SELECT _tmpMobileEmployeeTariff.Navigator
                              FROM _tmpMobileEmployeeTariff
                              WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone):: tfloat
      -- 
        , inPrevNavigator := 0 :: tfloat 
        , inLimit := (SELECT _tmpMobileEmployeeTariff.MobileLimit
                      FROM _tmpMobileEmployeeTariff
                      WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone):: tfloat
        , inPrevLimit := 0 :: tfloat
    -- Служебный лимит
        , inDutyLimit := (SELECT _tmpMobileEmployeeTariff.DutyLimit
                      FROM _tmpMobileEmployeeTariff
                      WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone):: tfloat
      -- Перелимит
        , inOverlimit := (SELECT CASE WHEN (vbRecord.TotalSum - (_tmpMobileEmployeeTariff.MobileLimit +_tmpMobileEmployeeTariff.DutyLimit)) > 0 
                                      THEN (vbRecord.TotalSum - (_tmpMobileEmployeeTariff.MobileLimit +_tmpMobileEmployeeTariff.DutyLimit))
                                      ELSE 0
                                 END
                          FROM _tmpMobileEmployeeTariff
                          WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone):: tfloat
        , inPrevMonthly := 0 :: tfloat
      -- Регион
        , inRegionId := 0
      -- ИД сотрудника                
	, inEmployeeID := (SELECT _tmpMobileEmployeeTariff.PersonalId
                           FROM _tmpMobileEmployeeTariff
                           WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone)::INTEGER
        , inPrevEmployeeId := 0
      -- ИД тарифа
        , inMobileTariffID := (SELECT _tmpMobileEmployeeTariff.TariffId
                               FROM _tmpMobileEmployeeTariff
                               WHERE RIGHT(_tmpMobileEmployeeTariff.MobileNum, 10) = vbRecord.MobilePhone)::INTEGER
        , inPrevMobileTariffId := 0
        , inUserId := vbUserId

        );
    END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.10.16         * parce
 30.09.16         *
*/

-- тест
-- 