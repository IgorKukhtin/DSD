-- Function: gpSelect_GoodsOnUnitRemains_ForTabletkiGroup

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForTabletkiGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletkiGroup(
    IN inUnitId  Integer,   -- Подразделение
    IN inSession TVarChar   -- сессия пользователя
)
RETURNS TABLE (RowData  TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
                       (SELECT DISTINCT Container.ObjectId
                        FROM
                            Container
                            INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId
                                                 AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId      = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId        = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                        WHERE Container.DescId        = zc_Container_Count()
                          AND (Container.WhereObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
                          AND Container.Amount        <> 0
                       );
                       
    ANALYSE tmpContainer;
    

    CREATE TEMP TABLE tmpMakerNameAll ON COMMIT DROP AS
                           (SELECT  Object_Goods_Juridical.GoodsMainId
                                   , replace(replace(replace(COALESCE(Object_Goods_Juridical.MakerName, ''),'"',''),'&','&amp;'),'''','') AS MakerName
                                   , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId ORDER BY Object_Goods_Juridical.JuridicalId) as ORD
                            FROM
                                Object_Goods_Juridical
                            WHERE COALESCE(Object_Goods_Juridical.MakerName, '') <> ''
                           );
                       
    ANALYSE tmpMakerNameAll;


    CREATE TEMP TABLE tmpObjectHistory ON COMMIT DROP AS
                             (SELECT *
                              FROM ObjectHistory
                              WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                              );
                       
    ANALYSE tmpObjectHistory;
    

raise notice 'Value 1: %', CLOCK_TIMESTAMP();

    RETURN QUERY
    WITH
         tmpMakerName AS (SELECT tmpMakerNameAll.GoodsMainId
                               , tmpMakerNameAll.MakerName
                          FROM tmpMakerNameAll
                          WHERE tmpMakerNameAll.ORD = 1)
       , tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                        AS JuridicalId
                                      , COALESCE(ObjectHistory_JuridicalDetails.StartDate, zc_DateStart())             AS StartDate
                                      , ObjectHistoryString_JuridicalDetails_FullName.ValueData                        AS FullName
                                      , ObjectHistoryString_JuridicalDetails_JuridicalAddress.ValueData                AS JuridicalAddress
                                      , ObjectHistoryString_JuridicalDetails_OKPO.ValueData                            AS OKPO
                                      , ObjectHistoryString_JuridicalDetails_INN.ValueData                             AS INN
                                      , ObjectHistoryString_JuridicalDetails_NumberVAT.ValueData                       AS NumberVAT
                                      , ObjectHistoryString_JuridicalDetails_AccounterName.ValueData                   AS AccounterName
                                      , ObjectHistoryString_JuridicalDetails_BankAccount.ValueData                     AS BankAccount
                                      , ObjectHistoryString_JuridicalDetails_Phone.ValueData                           AS Phone

                                      , ObjectHistoryString_JuridicalDetails_MainName.ValueData                        AS MainName
                                      , ObjectHistoryString_JuridicalDetails_MainName_Cut.ValueData                    AS MainName_Cut
                                      , ObjectHistoryString_JuridicalDetails_Reestr.ValueData                          AS Reestr
                                      , ObjectHistoryString_JuridicalDetails_Decision.ValueData                        AS Decision
                                      , ObjectHistoryString_JuridicalDetails_License.ValueData                         AS License
                                      , ObjectHistoryDate_JuridicalDetails_Decision.ValueData                          AS DecisionDate

                                 FROM tmpObjectHistory AS ObjectHistory_JuridicalDetails
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
                                             ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_JuridicalAddress
                                             ON ObjectHistoryString_JuridicalDetails_JuridicalAddress.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_JuridicalAddress.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                             ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
                                             ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_NumberVAT
                                             ON ObjectHistoryString_JuridicalDetails_NumberVAT.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_NumberVAT.DescId = zc_ObjectHistoryString_JuridicalDetails_NumberVAT()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_AccounterName
                                             ON ObjectHistoryString_JuridicalDetails_AccounterName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_AccounterName.DescId = zc_ObjectHistoryString_JuridicalDetails_AccounterName()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_BankAccount
                                             ON ObjectHistoryString_JuridicalDetails_BankAccount.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_BankAccount.DescId = zc_ObjectHistoryString_JuridicalDetails_BankAccount()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Phone
                                             ON ObjectHistoryString_JuridicalDetails_Phone.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_Phone.DescId = zc_ObjectHistoryString_JuridicalDetails_Phone()

                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName
                                             ON ObjectHistoryString_JuridicalDetails_MainName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_MainName.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName_Cut
                                             ON ObjectHistoryString_JuridicalDetails_MainName_Cut.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_MainName_Cut.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName_Cut()

                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Reestr
                                             ON ObjectHistoryString_JuridicalDetails_Reestr.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_Reestr.DescId = zc_ObjectHistoryString_JuridicalDetails_Reestr()
                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Decision
                                             ON ObjectHistoryString_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_Decision.DescId = zc_ObjectHistoryString_JuridicalDetails_Decision()

                                      LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_License
                                             ON ObjectHistoryString_JuridicalDetails_License.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryString_JuridicalDetails_License.DescId = zc_ObjectHistoryString_JuridicalDetails_License()

                                      LEFT JOIN ObjectHistoryDate AS ObjectHistoryDate_JuridicalDetails_Decision
                                             ON ObjectHistoryDate_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                            AND ObjectHistoryDate_JuridicalDetails_Decision.DescId = zc_ObjectHistoryDate_JuridicalDetails_Decision()
                                 )
       , tmpJuridicalAll AS (SELECT Object_Goods_Juridical.GoodsMainId
                                  , Object_Goods_Juridical.JuridicalID
                                  , replace(replace(replace(COALESCE(Object_Goods_Juridical.Code, ''), '"', ''),'&','&amp;'),'''','')  AS Code
                                  , CASE tmpJuridicalDetails.OKPO WHEN '21642228' THEN 2
                                                                  WHEN '21643699' THEN 3
                                                                  WHEN '25184975' THEN 6
                                                                  WHEN '31816235' THEN 7
                                                                  WHEN '21194014' THEN 8
                                                                  WHEN '21947206' THEN 9
                                                                  WHEN '13808034' THEN 10
                                                                  WHEN '35431349' THEN 11 END AS JuridicalCode
                                  , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId ORDER BY Object_Goods_Juridical.JuridicalID) as ORD
                             FROM
                                 Object_Goods_Juridical
                                 INNER JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalID = Object_Goods_Juridical.JuridicalID
                             WHERE COALESCE( Object_Goods_Juridical.Code, '') <> ''
                             )
       , tmpJuridical AS (SELECT tmpJuridicalAll.GoodsMainId
                               , tmpJuridicalAll.Code
                               , tmpJuridicalAll.JuridicalCode
                          FROM tmpJuridicalAll
                          WHERE tmpJuridicalAll.ORD = 1)
       , tmpJuridicalGroup AS (SELECT tmpJuridical.GoodsMainId
                                    , COALESCE(Juridical2.Code, '') AS Code2
                                    , COALESCE(Juridical3.Code, '') AS Code3
                                    , COALESCE(Juridical6.Code, '') AS Code6
                                    , COALESCE(Juridical7.Code, '') AS Code7
                                    , COALESCE(Juridical8.Code, '') AS Code8
                                    , COALESCE(Juridical9.Code, '') AS Code9
                                    , COALESCE(Juridical10.Code, '') AS Code10
                                    , COALESCE(Juridical11.Code, '') AS Code11
                             FROM (SELECT  DISTINCT tmpJuridical.GoodsMainId FROM tmpJuridical) AS tmpJuridical

                                  LEFT JOIN tmpJuridical AS Juridical2
                                                         ON Juridical2.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical2.JuridicalCode = 2
                                  LEFT JOIN tmpJuridical AS Juridical3
                                                         ON Juridical3.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical3.JuridicalCode = 3
                                  LEFT JOIN tmpJuridical AS Juridical6
                                                         ON Juridical6.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical6.JuridicalCode = 6
                                  LEFT JOIN tmpJuridical AS Juridical7
                                                         ON Juridical7.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical7.JuridicalCode = 7
                                  LEFT JOIN tmpJuridical AS Juridical8
                                                         ON Juridical8.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical8.JuridicalCode = 8
                                  LEFT JOIN tmpJuridical AS Juridical9
                                                         ON Juridical9.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical9.JuridicalCode = 9
                                  LEFT JOIN tmpJuridical AS Juridical10
                                                         ON Juridical10.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical10.JuridicalCode = 10
                                  LEFT JOIN tmpJuridical AS Juridical11
                                                         ON Juridical11.GoodsMainId = tmpJuridical.GoodsMainId
                                                        AND Juridical11.JuridicalCode = 11
                             )
 -- Штрих-коды производителя
       , tmpGoodsBarCode AS (SELECT Object_Goods_BarCode.GoodsMainId
                                  , string_agg(replace(replace(replace(COALESCE(Object_Goods_BarCode.BarCode, ''), '"', ''),'&','&amp;'),'''',''), ',' ORDER BY Object_Goods_BarCode.GoodsMainId, Object_Goods_BarCode.Id desc) AS BarCode
                             FROM Object_Goods_BarCode
                             GROUP BY Object_Goods_BarCode.GoodsMainId
                             )

                      --Шапка
                      SELECT '<?xml version="1.0" encoding="utf-8"?>'::TBlob AS RowData
                      UNION ALL
                      SELECT '<Data>'::TBlob
                      UNION ALL
                      SELECT '  <Offers>'::TBlob
                      UNION ALL
                      --Тело
                        SELECT
                            ('    <Offer Code="'||CAST(Object_Goods_Main.ObjectCode AS TVarChar)
                               ||'" Name="'||replace(replace(replace(Object_Goods_Main.Name, '"', ''),'&','&amp;'),'''','')
                               ||'" Producer="'||COALESCE(tmpMakerName.MakerName, '')
                               ||'" Barcode ="'||COALESCE(tmpGoodsBarCode.BarCode, '')
                               ||'" Code1="'||COALESCE(Object_Goods_Main.MorionCode::TVarChar, '')
                               ||'" Code2="'||COALESCE(Juridical.Code2, '')
                               ||'" Code3="'||COALESCE(Juridical.Code3, '')
                               ||'" Code6="'||COALESCE(Juridical.Code6, '')
                               ||'" Code7="'||COALESCE(Juridical.Code7, '')
                               ||'" Code8="'||COALESCE(Juridical.Code8, '')
                               ||'" Code9="'||COALESCE(Juridical.Code9, '')
                               ||'" Code10="'||COALESCE(Juridical.Code10, '')
                               ||'" Code11="'||COALESCE(Juridical.Code11, '')
                               ||'" />')::TBlob

                        FROM tmpContainer

                             INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.ObjectId
                             INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                             LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id

                             LEFT JOIN tmpMakerName ON tmpMakerName.GoodsMainId = Object_Goods_Main.Id

                             LEFT JOIN tmpJuridicalGroup AS Juridical
                                                         ON Juridical.GoodsMainId = Object_Goods_Main.Id

                        WHERE COALESCE (Object_Goods_Main.isNotUploadSites, FALSE) = FALSE
                          AND Object_Goods_Main.Name NOT ILIKE '%Спеццена%'
                          AND Object_Goods_Main.ObjectCode NOT IN (3274, 17789)

                      UNION ALL
                      -- подва
                      SELECT '  </Offers>'::TBlob
                      UNION ALL
                      SELECT '</Data>'::TBlob;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletkiGroup (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.19                                                       *
*/

-- тест
--

--SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletkiGroup (inUnitId := 183292, inSession:= '-3')
--SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletkiGroup (0, '3')