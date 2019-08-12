-- Function: gpInsert_Object_wms_CLIENT(TVarChar)
-- 4.1.1.3 —правочник контрагентов <client>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_CLIENT (VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_CLIENT(
    IN inSession       VarChar(255)       -- сесси€ пользовател€
)
-- RETURNS TABLE (ProcName TVarChar, RowNum Integer, RowData Text, ObjectId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName TVarChar;
   DECLARE vbRowNum   Integer;
BEGIN
     vbProcName:= 'gpInsert_Object_wms_CLIENT';

     -- проверка прав пользовател€ на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());



     -- удалили прошлые данные
     DELETE FROM Object_WMS WHERE Object_WMS.ProcName = vbProcName;

     -- первые строчки XML
     -- vbRowNum:= 1;
     -- INSERT INTO Object_WMS (ProcName, RowNum, RowData) VALUES (vbProcName, vbRowNum, '<?xml version="1.0" encoding="UTF-16"?>');


     -- –езультат
     -- RETURN QUERY
     -- –езультат - сформировали новые данные - Ёлементы XML
     INSERT INTO Object_WMS (ProcName, RowNum, RowData, ObjectId)
        WITH tmpPartner AS (SELECT Object_Partner.DescId, Object_Partner.Id AS client_id, Object_Partner.ValueData AS name
                                 , COALESCE (ObjectString_Address.ValueData, '')            AS address
                            FROM Object AS Object_Partner
                                 INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                      AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                                      ON ObjectLink_Juridical_JuridicalGroup.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_JuridicalGroup.DescId   = zc_ObjectLink_Juridical_JuridicalGroup()
                                 LEFT JOIN ObjectString AS ObjectString_Address
                                                        ON ObjectString_Address.ObjectId = Object_Partner.Id
                                                       AND ObjectString_Address.DescId   = zc_ObjectString_Partner_Address()
                            WHERE Object_Partner.DescId   = zc_Object_Partner()
                              AND Object_Partner.isErased = FALSE
                              AND ObjectLink_Juridical_JuridicalGroup.ChildObjectId = 257163 -- покупатели ƒнепр
 
                           UNION ALL
                            SELECT Object_Unit.DescId, Object_Unit.Id AS client_id, Object_Unit.ValueData AS name
                                 , COALESCE (ObjectString_Address.ValueData, '')            AS address
                            FROM Object AS Object_Unit
                                 INNER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                       ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                                      AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                                 INNER JOIN ObjectLink AS ObjectLink_Unit_Parent_0
                                                       ON ObjectLink_Unit_Parent_0.ObjectId = Object_Unit.Id
                                                      AND ObjectLink_Unit_Parent_0.DescId   = zc_ObjectLink_Unit_Parent()
                                 INNER JOIN ObjectLink AS ObjectLink_Unit_Parent_1
                                                       ON ObjectLink_Unit_Parent_1.ObjectId      = ObjectLink_Unit_Parent_0.ChildObjectId
                                                      AND ObjectLink_Unit_Parent_1.DescId        = zc_ObjectLink_Unit_Parent()
                                                      AND ObjectLink_Unit_Parent_1.ChildObjectId = 8406 -- ‘илиалы
                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                                      ON ObjectLink_Unit_HistoryCost.ObjectId = Object_Unit.Id
                                                     AND ObjectLink_Unit_HistoryCost.DescId   = zc_ObjectLink_Unit_HistoryCost()
                                 LEFT JOIN ObjectString AS ObjectString_Address
                                                        ON ObjectString_Address.ObjectId = Object_Unit.Id
                                                       AND ObjectString_Address.DescId   = zc_ObjectString_Unit_Address()
                                                       AND 1=0
                            WHERE Object_Unit.DescId   = zc_Object_Unit()
                              AND Object_Unit.isErased = FALSE
                              AND ObjectLink_Unit_HistoryCost.ChildObjectId IS NULL
                           )
        -- –езультат
        SELECT vbProcName AS ProcName
             , (COALESCE (vbRowNum, 0) + ROW_NUMBER() OVER (ORDER BY tmpData.DescId, tmpData.client_id) :: Integer) AS RowNum
               -- XML
             , ('<client'
               ||' client_id=У' || tmpData.client_id    :: TVarChar ||'"' -- ”никальный идентификатор клиента
                    ||' name=У' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.name, CHR(39), '`'), '"', '`') ||'"' -- »м€ клиента
              ||' short_name=У' || ''                               ||'"' --  ороткое им€ клиента
                 ||' address=У' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.address, CHR(39), '`'), '"', '`') ||'"' -- јдрес клиента
                   ||' phone=У' || ''                               ||'"' -- “елефон клиента
                   ||' email=У' || ''                               ||'"' -- E-mail клиента
                     ||' fax=У' || ''                               ||'"' -- ‘акс клиента
             ||' is_customer=У' || CASE WHEN tmpData.DescId = zc_Object_Partner() THEN 't' ELSE 'f' END :: TVarChar ||'"' -- явл€етс€ ли контрагент покупателем: УfФ Ц не €вл€етс€, УtФ Ц €вл€етс€. «начение по умолчанию: УfФ
             ||' is_supplier=У' || 'f'                              ||'"' -- явл€етс€ ли контрагент поставщиком: УfФ Ц не €вл€етс€, УtФ Ц €вл€етс€. «начение по умолчанию: УfФ
         ||' is_manufacturer=У' || 'f'                              ||'"' -- явл€етс€ ли контрагент производителем: УfФ Ц не €вл€етс€, УtФ Ц €вл€етс€. «начение по умолчанию: УfФ
                ||' comments=У' || ''                               ||'"' --  омментарии
                ||' </client>'
               ):: Text AS RowData
               -- Id
             , tmpData.client_id
        FROM tmpPartner AS tmpData
        ORDER BY 2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
              ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».
 10.08.19                                       *
*/
-- тест
-- SELECT * FROM gpInsert_Object_wms_CLIENT (zfCalc_UserAdmin())
