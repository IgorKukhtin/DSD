-- Function: gpGet_AutoCalculation_SAUA()

DROP FUNCTION IF EXISTS gpGet_AutoCalculation_SAUA (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_AutoCalculation_SAUA(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (UnitId Integer, UnitName TVarChar
             , UnitRecipient Text, UnitAssortment Text, UnitAssortmentName Text

             , DateStart TDateTime, DateEnd TDateTime
             , Threshold TFloat, DaysStock Integer, CountPharmacies Integer, ResolutionParameter TFloat                                       
             , isGoodsClose boolean, isMCSIsClose boolean, isNotCheckNoMCS boolean, isAssortmentRound boolean, isNeedRound boolean
             
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbLatitude Float;
  DECLARE vbLongitude Float;
  DECLARE vbRealization TFloat;
  DECLARE vbOperDate TDateTime;
  DECLARE vbMethodsAssortmentId Integer;
  DECLARE vbAssortmentGeograph Integer;
  DECLARE vbAssortmentSales Integer;

  DECLARE vbUnit1GeographId Text;
  DECLARE vbUnit1GeographName Text;
  DECLARE vbUnitSalesId Text;
  DECLARE vbUnitSalesName Text;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_FinalSUA());
    vbUserId := inSession;
    
    vbOperDate := CURRENT_DATE + ((8 - date_part('DOW', CURRENT_DATE)::Integer)::TVarChar||' DAY')::INTERVAL;
    vbUnit1GeographId := '';
    vbUnit1GeographName := '';
    vbUnitSalesId := '';
    vbUnitSalesName := '';

    SELECT ObjectLink_CashSettings_MethodsAssortment.ChildObjectId
         , ObjectFloat_CashSettings_AssortmentGeograph.ValueData::Integer           AS AssortmentGeograph
         , ObjectFloat_CashSettings_AssortmentSales.ValueData::Integer              AS AssortmentSales
    INTO vbMethodsAssortmentId
       , vbAssortmentGeograph
       , vbAssortmentSales
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectLink AS ObjectLink_CashSettings_MethodsAssortment
                              ON ObjectLink_CashSettings_MethodsAssortment.ObjectId = Object_CashSettings.Id
                             AND ObjectLink_CashSettings_MethodsAssortment.DescId = zc_ObjectLink_CashSettings_MethodsAssortment()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AssortmentGeograph
                               ON ObjectFloat_CashSettings_AssortmentGeograph.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_AssortmentGeograph.DescId = zc_ObjectFloat_CashSettings_AssortmentGeograph()
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AssortmentSales
                               ON ObjectFloat_CashSettings_AssortmentSales.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_AssortmentSales.DescId = zc_ObjectFloat_CashSettings_AssortmentSales()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;

    CREATE TEMP TABLE _tmpUnit ON COMMIT DROP AS (  
    WITH tmpUnit AS (SELECT Object_Unit.Id                AS UnitId
                          , Object_Unit.ValueData         AS UnitName
                          , Object_Juridical.ValueData    AS JuridicalName
                          , ROW_NUMBER()OVER(ORDER BY Object_Juridical.ValueData, Object_Unit.ValueData) as ORD
                     FROM ObjectBoolean AS ObjectBoolean_Unit_SUA

                          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectBoolean_Unit_SUA.ObjectId

                          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
                                                   
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                     WHERE ObjectBoolean_Unit_SUA.DescId = zc_ObjectBoolean_Unit_SUA()
                       AND ObjectBoolean_Unit_SUA.ValueData = True
                     ORDER BY Object_Juridical.ValueData
                            , Object_Unit.ValueData
                     )                              
                              
    SELECT tmpUnit.UnitId
         , tmpUnit.UnitName
         , tmpUnit.JuridicalName
         , ObjectDate_AutoSUA.ValueData                                                               AS DateAuto 
         , COALESCE(NULLIF(ObjectString_Latitude.ValueData, ''), '0')::FLOAT                          AS Latitude 
         , COALESCE(NULLIF(ObjectString_Longitude.ValueData, ''), '0')::FLOAT                         AS Longitude
         , tmpUnit.ORD                                                                                AS ORD
         , 0::TFloat                                                                                  AS Realization
    FROM tmpUnit
         LEFT JOIN ObjectString AS ObjectString_Latitude
                                ON ObjectString_Latitude.ObjectId = tmpUnit.UnitId
                               AND ObjectString_Latitude.DescId = zc_ObjectString_Unit_Latitude()
         LEFT JOIN ObjectString AS ObjectString_Longitude
                                ON ObjectString_Longitude.ObjectId = tmpUnit.UnitId
                               AND ObjectString_Longitude.DescId = zc_ObjectString_Unit_Longitude()
         LEFT JOIN ObjectDate AS ObjectDate_AutoSUA
                              ON ObjectDate_AutoSUA.ObjectId = tmpUnit.UnitId
                             AND ObjectDate_AutoSUA.DescId = zc_ObjectDate_Unit_AutoSUA()
         );
         
    IF vbMethodsAssortmentId in (zc_Enum_MethodsAssortment_Sales(), zc_Enum_MethodsAssortment_GeographSales()) 
    THEN
    
      UPDATE _tmpUnit SET Realization = R.AmountSum
      FROM (SELECT AnalysisContainerItem.UnitID
                 , Sum(COALESCE(AnalysisContainerItem.AmountCheckSum, 0))        AS AmountSum
            FROM AnalysisContainerItem
            WHERE AnalysisContainerItem.OperDate >= DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 MONTH'
              AND AnalysisContainerItem.OperDate < DATE_TRUNC ('month', CURRENT_DATE)
              AND AnalysisContainerItem.UnitID IN (SELECT _tmpUnit.UnitId FROM _tmpUnit)
              AND AnalysisContainerItem.AmountCheckSum > 0
              AND AnalysisContainerItem.GoodsId NOT IN (SELECT Object_Goods_Retail.ID
                                                        FROM Object_Goods_Retail
                                                        WHERE (COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                                           OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0))
            GROUP BY AnalysisContainerItem.UnitID) AS R
      WHERE _tmpUnit.UnitId = R.UnitId;
    
    END IF;
             
    -- Выбераем аптеку
    IF EXISTS(SELECT * FROM _tmpUnit WHERE _tmpUnit.DateAuto = vbOperDate)
    THEN
      SELECT _tmpUnit.UnitId
           , _tmpUnit.Latitude
           , _tmpUnit.Longitude
           , _tmpUnit.Realization
      INTO vbUnitId
         , vbLatitude
         , vbLongitude
         , vbRealization
      FROM _tmpUnit
      WHERE _tmpUnit.DateAuto = vbOperDate;    
    ELSEIF EXISTS(SELECT * FROM _tmpUnit WHERE _tmpUnit.DateAuto is Null)
    THEN
      SELECT _tmpUnit.UnitId
           , _tmpUnit.Latitude
           , _tmpUnit.Longitude
      INTO vbUnitId
         , vbLatitude
         , vbLongitude
      FROM _tmpUnit
      WHERE _tmpUnit.DateAuto is Null
      ORDER BY ORD
      LIMIT 1;                              
    ELSE
      SELECT _tmpUnit.UnitId
           , _tmpUnit.Latitude
           , _tmpUnit.Longitude
      INTO vbUnitId
         , vbLatitude
         , vbLongitude
      FROM _tmpUnit
      ORDER BY _tmpUnit.DateAuto
      LIMIT 1;                              
    END IF; 
    
    IF COALESCE (vbUnitId, 0) = 0
    THEN
       RAISE EXCEPTION 'Ошибка. Не нашлась аптека.';   
    END IF;

    -- сохранили свойство <Дату авто пересчета>
    PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_AutoSUA(), vbUnitId, vbOperDate);
    
    
    -- Выбераем ближайшие аптеки

    IF vbMethodsAssortmentId = zc_Enum_MethodsAssortment_Geographically()
    THEN
    
      IF COALESCE(vbAssortmentGeograph, 0) < 3 
      THEN
        vbAssortmentGeograph := 3;
      END IF;
      
      WITH tmpUnitAll AS (SELECT _tmpUnit.UnitId
                               , _tmpUnit.UnitName
                               , |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude - vbLongitude)^2)
                               , ROW_NUMBER()OVER(ORDER BY |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude -vbLongitude)^2)) as ORD 
                          FROM _tmpUnit      
                          WHERE _tmpUnit.UnitId <> vbUnitId)      
                                   
      SELECT string_agg(tmpUnitAll1.UnitId::TVarChar, ',')
           , string_agg(tmpUnitAll1.UnitName::TVarChar, CHR(13))
      INTO vbUnit1GeographId
         , vbUnit1GeographName
      FROM tmpUnitAll AS tmpUnitAll1
      WHERE tmpUnitAll1.ORD <= vbAssortmentGeograph;

    ELSEIF vbMethodsAssortmentId = zc_Enum_MethodsAssortment_Sales()
    THEN
    
      IF COALESCE(vbAssortmentSales, 0) < 3 
      THEN
        vbAssortmentSales := 3;
      END IF;

      WITH tmpUnitAll AS (SELECT _tmpUnit.UnitId
                               , _tmpUnit.UnitName
                               , |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude - vbLongitude)^2)
                               , ROW_NUMBER()OVER(ORDER BY ABS(_tmpUnit.Realization - vbRealization), |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude -vbLongitude)^2)) as ORD 
                          FROM _tmpUnit      
                          WHERE _tmpUnit.UnitId <> vbUnitId)      
                                   
      SELECT string_agg(tmpUnitAll1.UnitId::TVarChar, ',')
           , string_agg(tmpUnitAll1.UnitName::TVarChar, CHR(13))
      INTO vbUnitSalesId
         , vbUnitSalesName
      FROM tmpUnitAll AS tmpUnitAll1
      WHERE tmpUnitAll1.ORD <= vbAssortmentSales;

    ELSEIF vbMethodsAssortmentId = zc_Enum_MethodsAssortment_GeographSales()
    THEN

      IF COALESCE(vbAssortmentGeograph, 0) = 0
      THEN
        vbAssortmentGeograph := 0;
      END IF;


      IF (COALESCE(vbAssortmentSales, 0) + vbAssortmentGeograph) < 3 
      THEN
        vbAssortmentSales := 3 - vbAssortmentGeograph;
      END IF;

      IF COALESCE(vbAssortmentGeograph, 0) > 0
      THEN
        WITH tmpUnitAll AS (SELECT _tmpUnit.UnitId
                                 , _tmpUnit.UnitName
                                 , |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude - vbLongitude)^2)
                                 , ROW_NUMBER()OVER(ORDER BY |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude -vbLongitude)^2)) as ORD 
                            FROM _tmpUnit      
                            WHERE _tmpUnit.UnitId <> vbUnitId)      
                                     
        SELECT string_agg(tmpUnitAll1.UnitId::TVarChar, ',')
             , string_agg(tmpUnitAll1.UnitName::TVarChar, CHR(13))
        INTO vbUnit1GeographId
           , vbUnit1GeographName
        FROM tmpUnitAll AS tmpUnitAll1
        WHERE tmpUnitAll1.ORD <= vbAssortmentGeograph;
      END IF;
      
      
      IF COALESCE(vbAssortmentSales, 0) > 0
      THEN
        WITH tmpUnitAll AS (SELECT _tmpUnit.UnitId
                                 , _tmpUnit.UnitName
                                 , |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude - vbLongitude)^2)
                                 , ROW_NUMBER()OVER(ORDER BY ABS(_tmpUnit.Realization - vbRealization), |/((_tmpUnit.Latitude - vbLatitude)^2 + (_tmpUnit.Longitude -vbLongitude)^2)) as ORD 
                            FROM _tmpUnit      
                            WHERE _tmpUnit.UnitId <> vbUnitId
                              AND ','||vbUnit1GeographId||',' NOT LIKE '%,'||_tmpUnit.UnitId::TEXT||',%'
)      
                                       
        SELECT string_agg(tmpUnitAll1.UnitId::TVarChar, ',')
             , string_agg(tmpUnitAll1.UnitName::TVarChar, CHR(13))
        INTO vbUnitSalesId
           , vbUnitSalesName
        FROM tmpUnitAll AS tmpUnitAll1
        WHERE tmpUnitAll1.ORD <= vbAssortmentSales;
      END IF;
    
    ELSE 
       RAISE EXCEPTION 'Ошибка. Не определен механизм расчета аптек ассортимента.';       
    END IF;
          
    
    RETURN QUERY    
    WITH tmpSUAProtocol AS (SELECT Object_FinalSUAProtocol.Id                         AS Id
                                 , ObjectDate_OperDate.ValueData                      AS OperDate
                                 , Object_User.ObjectCode                             AS UserCode
                                 , Object_User.ValueData                              AS UserName

                                 , ObjectDate_DateStart.ValueData                     AS DateStart
                                 , ObjectDate_DateEnd.ValueData                       AS DateEnd
                                   
                                 , ObjectFloat_Threshold.ValueData                    AS Threshold
                                 , ObjectFloat_DaysStock.ValueData                    AS DaysStock
                                 , ObjectFloat_CountPharmacies.ValueData              AS CountPharmacies
                                 , ObjectFloat_ResolutionParameter.ValueData          AS ResolutionParameter
                                   
                                 , ObjectBoolean_GoodsClose.ValueData                 AS isGoodsClose
                                 , ObjectBoolean_MCSIsClose.ValueData                 AS isMCSIsClose
                                 , ObjectBoolean_NotCheckNoMCS.ValueData              AS isNotCheckNoMCS
                                 , COALESCE(ObjectBoolean_AssortmentRound.ValueData, False)  AS isAssortmentRound
                                 , COALESCE(ObjectBoolean_NeedRound.ValueData, False)        AS isNeedRound
                                   
                            FROM Object AS Object_FinalSUAProtocol
                              
                                  INNER JOIN ObjectDate AS ObjectDate_OperDate
                                                        ON ObjectDate_OperDate.ObjectId = Object_FinalSUAProtocol.Id
                                                       AND ObjectDate_OperDate.DescId = zc_ObjectDate_FinalSUAProtocol_OperDate()

                                  LEFT JOIN ObjectLink AS ObjectLink_User
                                                       ON ObjectLink_User.ObjectId = Object_FinalSUAProtocol.Id
                                                      AND ObjectLink_User.DescId = zc_ObjectLink_FinalSUAProtocol_User()
                                  LEFT JOIN Object AS Object_User ON Object_User.ID = ObjectLink_User.ChildObjectId

                                  LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                                       ON ObjectDate_DateStart.ObjectId = Object_FinalSUAProtocol.Id
                                                      AND ObjectDate_DateStart.DescId = zc_ObjectDate_FinalSUAProtocol_DateStart()
                                  LEFT JOIN ObjectDate AS ObjectDate_DateEnd
                                                       ON ObjectDate_DateEnd.ObjectId = Object_FinalSUAProtocol.Id
                                                      AND ObjectDate_DateEnd.DescId = zc_ObjectDate_FinalSUAProtocol_DateEnd()

                                  LEFT JOIN ObjectFloat AS ObjectFloat_Threshold
                                                        ON ObjectFloat_Threshold.ObjectId = Object_FinalSUAProtocol.Id
                                                       AND ObjectFloat_Threshold.DescId = zc_ObjectFloat_FinalSUAProtocol_Threshold()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_DaysStock
                                                        ON ObjectFloat_DaysStock.ObjectId = Object_FinalSUAProtocol.Id
                                                       AND ObjectFloat_DaysStock.DescId = zc_ObjectFloat_FinalSUAProtocol_DaysStock()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_CountPharmacies
                                                        ON ObjectFloat_CountPharmacies.ObjectId = Object_FinalSUAProtocol.Id
                                                       AND ObjectFloat_CountPharmacies.DescId = zc_ObjectFloat_FinalSUAProtocol_CountPharmacies()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_ResolutionParameter
                                                        ON ObjectFloat_ResolutionParameter.ObjectId = Object_FinalSUAProtocol.Id
                                                       AND ObjectFloat_ResolutionParameter.DescId = zc_ObjectFloat_FinalSUAProtocol_ResolutionParameter()

                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsClose
                                                          ON ObjectBoolean_GoodsClose.ObjectId = Object_FinalSUAProtocol.Id
                                                         AND ObjectBoolean_GoodsClose.DescId = zc_ObjectBoolean_FinalSUAProtocol_GoodsClose()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_MCSIsClose
                                                          ON ObjectBoolean_MCSIsClose.ObjectId = Object_FinalSUAProtocol.Id
                                                         AND ObjectBoolean_MCSIsClose.DescId = zc_ObjectBoolean_FinalSUAProtocol_MCSIsClose()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCheckNoMCS
                                                          ON ObjectBoolean_NotCheckNoMCS.ObjectId = Object_FinalSUAProtocol.Id
                                                         AND ObjectBoolean_NotCheckNoMCS.DescId = zc_ObjectBoolean_FinalSUAProtocol_NotCheckNoMCS()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_AssortmentRound
                                                          ON ObjectBoolean_AssortmentRound.ObjectId = Object_FinalSUAProtocol.Id
                                                         AND ObjectBoolean_AssortmentRound.DescId = zc_ObjectBoolean_FinalSUAProtocol_AssortmentRound()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_NeedRound
                                                          ON ObjectBoolean_NeedRound.ObjectId = Object_FinalSUAProtocol.Id
                                                         AND ObjectBoolean_NeedRound.DescId = zc_ObjectBoolean_FinalSUAProtocol_NeedRound()
                                    
                            WHERE Object_FinalSUAProtocol.DescId = zc_Object_FinalSUAProtocol()
                              AND Object_FinalSUAProtocol.isErased = False
                            ORDER BY ObjectDate_OperDate.ValueData DESC
                            LIMIT 1
                            )
      
    SELECT Object_Unit.ID
         , Object_Unit.ValueData
         
         , Object_Unit.ID::Text            AS UnitRecipient
         , (vbUnit1GeographId||CASE WHEN vbUnit1GeographId <> '' AND vbUnitSalesId <> '' THEN ',' ELSE ''END||vbUnitSalesId)::Text AS UnitAssortment
         , (vbUnit1GeographName||CASE WHEN vbUnit1GeographName <> '' AND vbUnitSalesName <> '' THEN CHR(13) ELSE ''END||vbUnitSalesName)::Text AS UnitAssortmentName

         , (CURRENT_DATE - INTERVAL '46 DAY')::TDateTime
         , (CURRENT_DATE - INTERVAL '1 DAY')::TDateTime
                                   
         , tmpSUAProtocol.Threshold
         , tmpSUAProtocol.DaysStock::Integer
         , tmpSUAProtocol.CountPharmacies::Integer
         , tmpSUAProtocol.ResolutionParameter
                                   
         , tmpSUAProtocol.isGoodsClose
         , tmpSUAProtocol.isMCSIsClose
         , tmpSUAProtocol.isNotCheckNoMCS
         , tmpSUAProtocol.isAssortmentRound
         , tmpSUAProtocol.isNeedRound
         
    FROM Object AS Object_Unit
         LEFT JOIN tmpSUAProtocol ON 1 = 1 
    WHERE Object_Unit.ID = vbUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.05.21                                                       *
 */

-- тест
--
 
select * from gpGet_AutoCalculation_SAUA( inSession := '3');