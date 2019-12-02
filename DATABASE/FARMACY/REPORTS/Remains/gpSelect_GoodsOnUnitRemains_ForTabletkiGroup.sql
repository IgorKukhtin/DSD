-- Function: gpSelect_GoodsOnUnitRemains_ForTabletkiGroup

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForTabletkiGroup (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForTabletkiGroup(
    IN inUnitId  Integer = 183292, -- Подразделение
    IN inSession TVarChar = '' -- сессия пользователя
)
RETURNS TABLE (RowData  TBlob)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    WITH
       tmpContainer AS (SELECT DISTINCT Container.ObjectId
                        FROM
                            Container
                        WHERE Container.DescId        = zc_Container_Count()
                          AND Container.WhereObjectId = inUnitId
                          AND Container.Amount        <> 0
                       )
       , tmpMakerName AS (SELECT Object_Goods_Juridical.GoodsMainId
                               , Object_Goods_Juridical.MakerName
                               , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId ORDER BY Object_Goods_Juridical.JuridicalId) as ORD
                        FROM
                            Object_Goods_Juridical
                        WHERE COALESCE(Object_Goods_Juridical.MakerName, '') <> ''
                       )
       , tmpObjectHistory AS (SELECT *
                              FROM ObjectHistory
                              WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                              )
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
       , tmpJuridical AS (SELECT Object_Goods_Juridical.GoodsMainId
                               , Object_Goods_Juridical.JuridicalID
                               , Object_Goods_Juridical.Code
                               , CASE tmpJuridicalDetails.OKPO WHEN '21642228' THEN 2
                                                               WHEN '21643699' THEN 3
                                                               WHEN '25184975' THEN 6
                                                               WHEN '31816235' THEN 7
                                                               WHEN '21194014' THEN 8
                                                               WHEN '21947206' THEN 9
                                                               WHEN '13808034' THEN 10
                                                               WHEN '35431349' THEN 11 END AS JuridicalCode
                               , ROW_NUMBER()OVER(PARTITION BY Object_Goods_Juridical.GoodsMainId
                                                             , Object_Goods_Juridical.JuridicalID ORDER BY tmpJuridicalDetails.OKPO) as ORD
                        FROM
                            Object_Goods_Juridical

                            INNER JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalID = Object_Goods_Juridical.JuridicalID

                        WHERE COALESCE( Object_Goods_Juridical.Code, '') <> ''
                       )
 -- Штрих-коды производителя
       , tmpGoodsBarCode AS (SELECT Object_Goods_BarCode.GoodsMainId
                                  , string_agg(Object_Goods_BarCode.BarCode, ',' ORDER BY Object_Goods_BarCode.GoodsMainId, Object_Goods_BarCode.Id desc) AS BarCode
                             FROM Object_Goods_BarCode
                             GROUP BY Object_Goods_BarCode.GoodsMainId
                             )

       , tmpResult AS (
                      --Шапка
                      SELECT '<?xml version="1.0" encoding="utf-8"?>'::TVarChar AS RowData
                      UNION ALL
                      SELECT '<Data>'::TVarChar
                      UNION ALL
                      SELECT '  <Offers>'::TVarChar
                      UNION ALL
                      --Тело
                        SELECT
                            '    <Offer Code="'||CAST(Object_Goods_Main.ObjectCode AS TVarChar)
                               ||'" Name="'||replace(replace(replace(Object_Goods_Main.Name, '"', ''),'&','&amp;'),'''','')
                               ||'" Producer="'||replace(replace(replace(COALESCE(tmpMakerName.MakerName, ''),'"',''),'&','&amp;'),'''','')
                               ||'" Barcode ="'||replace(replace(replace(COALESCE(tmpGoodsBarCode.BarCode, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code1="'||replace(replace(replace(COALESCE(Object_Goods_Main.MorionCode::TVarChar, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code2="'||replace(replace(replace(COALESCE(Juridical2.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code3="'||replace(replace(replace(COALESCE(Juridical3.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code6="'||replace(replace(replace(COALESCE(Juridical6.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code7="'||replace(replace(replace(COALESCE(Juridical7.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code8="'||replace(replace(replace(COALESCE(Juridical8.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code9="'||replace(replace(replace(COALESCE(Juridical9.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code10="'||replace(replace(replace(COALESCE(Juridical10.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" Code11="'||replace(replace(replace(COALESCE(Juridical11.Code, ''), '"', ''),'&','&amp;'),'''','')
                               ||'" />'

                        FROM tmpContainer

                             INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpContainer.ObjectId
                             INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

                             LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Main.Id

                             LEFT JOIN tmpMakerName ON tmpMakerName.GoodsMainId = Object_Goods_Main.Id
                                                   AND tmpMakerName.ORD = 1

                             LEFT JOIN tmpJuridical AS Juridical2
                                                    ON Juridical2.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical2.JuridicalCode = 2
                                                   AND Juridical2.ORD = 1
                             LEFT JOIN tmpJuridical AS Juridical3
                                                    ON Juridical3.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical3.JuridicalCode = 3
                                                   AND Juridical3.ORD = 1
                             LEFT JOIN tmpJuridical AS Juridical6
                                                    ON Juridical6.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical6.JuridicalCode = 6
                                                   AND Juridical6.ORD = 1
                             LEFT JOIN tmpJuridical AS Juridical7
                                                    ON Juridical7.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical7.JuridicalCode = 7
                                                   AND Juridical7.ORD = 1
                             LEFT JOIN tmpJuridical AS Juridical8
                                                    ON Juridical8.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical8.JuridicalCode = 8
                                                   AND Juridical8.ORD = 1
                             LEFT JOIN tmpJuridical AS Juridical9
                                                    ON Juridical9.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical9.JuridicalCode = 9
                                                   AND Juridical9.ORD = 1
                             LEFT JOIN tmpJuridical AS Juridical10
                                                    ON Juridical10.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical10.JuridicalCode = 10
                                                   AND Juridical10.ORD = 1
                             LEFT JOIN tmpJuridical AS Juridical11
                                                    ON Juridical11.GoodsMainId = Object_Goods_Main.Id
                                                   AND Juridical11.JuridicalCode = 11
                                                   AND Juridical11.ORD = 1

                        WHERE COALESCE (Object_Goods_Main.isNotUploadSites, FALSE) = FALSE

                      UNION ALL
                      -- подва
                      SELECT '  </Offers>'
                      UNION ALL
                      SELECT '</Data>')

       SELECT tmpResult.RowData::TBlob FROM tmpResult;

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
-- SELECT * FROM gpSelect_GoodsOnUnitRemains_ForTabletkiGroup (inUnitId := 183292, inSession:= '-3')

