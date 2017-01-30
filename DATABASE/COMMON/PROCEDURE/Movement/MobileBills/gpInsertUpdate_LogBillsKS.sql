-- Function: gpInsertUpdate_LogBillsKS(tblob, tvarchar)

-- DROP FUNCTION gpInsertUpdate_LogBillsKS(tblob, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_LogBillsKS(
    inxmlfile tblob,
    insession tvarchar)
  RETURNS void AS
$BODY$
  DECLARE x TEXT;
  DECLARE xmlBillDate TDateTime;
  DECLARE r RECORD;
BEGIN

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
    CREATE TEMP TABLE _tmpEmployees (ID integer, Name TVarchar) ON COMMIT DROP;
    INSERT INTO _tmpEmployees (ID, Name)
	    SELECT ID, Name FROM gpSelect_Object_Member(TRUE, inSession);

  -- *** Парсим XML в таблицу
    CREATE TEMP TABLE _tmpReportMobileKS (MobilePhone TVarchar, TotalSum tfloat) ON COMMIT DROP;
    INSERT INTO _tmpReportMobileKS (MobilePhone, TotalSum)
    WITH x AS (
      SELECT xmldata::XML AS T FROM logBillsKS l WHERE l.BillDate = xmlBillDate
    )
    SELECT
    -- Номер мобильного
      regexp_split_to_table(replace(replace(CAST(xpath('//Array-Bill/bill/subs[stnd_id=1]/msisdn', T) AS TEXT), '}', ''), '{', ''), ',')::TVarchar AS MobilePhone
    -- Итого
      ,regexp_split_to_table(replace(replace(CAST(xpath('//Array-Bill/bill/subs[stnd_id=1]/s_det/tot', T) AS TEXT), '}', ''), '{', ''),',')::TFloat AS TotalSum
    FROM x;

  -- *** Заполняем таблицу журнала счетов
    FOR r IN (SELECT tmp.MobilePhone, tmp.TotalSum FROM _tmpReportMobileKS tmp)
    LOOP
      PERFORM gpInsertUpdate_dirMobileNumbersEmployeeLog(
      -- Указываем, что мы заливаем инфу с файла
        inID := -1::INTEGER

      -- ИД тарифа
        , inMobileTariffID := (SELECT mne.MobileTariffID FROM dirMobileNumbersEmployee mne
		                            LEFT JOIN dirMobileTariff AS mt ON mt.id = mne.MobileTariffID
                                WHERE RIGHT(mne.MobileNum, 10) = r.MobilePhone)::INTEGER

      -- Лимит
        , inLim := (SELECT mne.Lim FROM dirMobileNumbersEmployee AS mne WHERE RIGHT(mne.MobileNum, 10) = r.MobilePhone)::tfloat

      -- Служебный лимит
        , inLimitDuty := (SELECT mne.LimitDuty FROM dirMobileNumbersEmployee AS mne WHERE RIGHT(mne.MobileNum, 10) = r.MobilePhone)::tfloat

      -- Навигатор
	, inNavigator := (SELECT mne.Navigator FROM dirMobileNumbersEmployee AS mne
		                      LEFT JOIN dirMobileTariff AS mt ON mt.id = mne.MobileTariffID
		                      WHERE RIGHT(mne.MobileNum, 10) = r.MobilePhone):: tfloat

      -- Перелимит
        , inOverlimit := (SELECT ((mne.Lim + mne.LimitDuty) - r.TotalSum) FROM dirMobileNumbersEmployee AS mne
                     LEFT JOIN _tmpReportMobileKS as rm ON rm.MobilePhone = mne.mobilenum
                     WHERE RIGHT(mne.MobileNum, 10) = r.MobilePhone)::tfloat

      -- Абонплата
	, inMonthly := (SELECT mt.Monthly FROM dirMobileNumbersEmployee AS mne
		                    LEFT JOIN dirMobileTariff AS mt ON mt.id = mne.MobileTariffID
                        WHERE RIGHT(mne.MobileNum, 10) = r.MobilePhone):: tfloat

      -- ИД сотрудника                
	, inEmployeeID := (SELECT e.ID FROM _tmpEmployees e
		                      LEFT JOIN dirMobileNumbersEmployee AS mne ON mne.EmployeeID = e.ID
		                      WHERE r.MobilePhone = RIGHT(mne.MobileNum, 10))::INTEGER

      -- Комментарии
        , inComms := ''::tvarchar

      -- Номер мобильного
        , inMobileNum := r.MobilePhone::tvarchar

      -- Дата счета
        , inChangeDate := xmlBillDate::tdatetime

      -- Регион
        , inRegion := (SELECT mne.Region FROM dirMobileNumbersEmployee AS mne WHERE RIGHT(mne.MobileNum, 10) = r.MobilePhone)::TVarchar

      -- Сумма итого
        , inTotalSum := r.TotalSum

      -- Всегда внизу
        , inSession := ''::TVarChar
      );
    END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_LogBillsKS(tblob, tvarchar)
  OWNER TO admin;
GRANT EXECUTE ON FUNCTION gpInsertUpdate_LogBillsKS(tblob, tvarchar) TO public;
GRANT EXECUTE ON FUNCTION gpInsertUpdate_LogBillsKS(tblob, tvarchar) TO admin;
GRANT EXECUTE ON FUNCTION gpInsertUpdate_LogBillsKS(tblob, tvarchar) TO project;
