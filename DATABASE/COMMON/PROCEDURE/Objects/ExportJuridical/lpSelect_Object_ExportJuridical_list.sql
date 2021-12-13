-- Function: lpSelect_Object_ExportJuridical_list ()

DROP FUNCTION IF EXISTS lpSelect_Object_ExportJuridical_list ();

CREATE OR REPLACE FUNCTION lpSelect_Object_ExportJuridical_list(
)
RETURNS TABLE (ExportKindId Integer, ExportKindCode Integer, ExportKindName TVarChar
             , ContactPersonMail TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar, isErased Boolean
             , EmailKindId Integer, EmailKindCode Integer, EmailKindName TVarChar
             , ObjectDescName TVarChar, ObjectCode Integer, ObjectName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , Id Integer, Code Integer, Name TVarChar
             , isAuto Boolean
              )
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY
       WITH tmpList_all AS (SELECT tmp.*, Object.DescId AS ObjectDescId
                            FROM (SELECT Object_ExportJuridical.Id
                                       , Object_ExportJuridical.ObjectCode AS Code
                                       , Object_ExportJuridical.ValueData  AS Name
                                       , CASE -- первый приоритет - если установлен Договор
                                              WHEN ObjectLink_Contract_Juridical.ChildObjectId <> 0
                                                   THEN ObjectLink_Contract_Juridical.ChildObjectId
                                              -- второй приоритет - если установлено Юр Лицо
                                              WHEN ObjectLink_ExportJuridical_Juridical.ChildObjectId <> 0
                                                   THEN ObjectLink_ExportJuridical_Juridical.ChildObjectId
                                              -- третий приоритет - если установлена Торговая сеть
                                              WHEN ExportJuridical_Retail.ChildObjectId <> 0
                                                   THEN ExportJuridical_Retail.ChildObjectId
                                         END AS ObjectId

                                       , COALESCE (ObjectLink_ExportJuridical_Contract.ChildObjectId, 0) AS ContractId

                                       , CASE -- первый приоритет - если установлен Договор
                                              WHEN ObjectLink_Contract_InfoMoney.ChildObjectId <> 0
                                                   THEN ObjectLink_Contract_InfoMoney.ChildObjectId
                                              -- иначе - ориентир на установленную УП статью
                                              ELSE COALESCE (ObjectLink_ExportJuridical_InfoMoney.ChildObjectId, 0)
                                         END AS InfoMoneyId

                                       , ObjectString_ContactPersonMail.ValueData            AS ContactPersonMail
                                       , ObjectLink_EmailKind.ChildObjectId                  AS EmailKindId
                                       , ObjectLink_ExportJuridical_ExportKind.ChildObjectId AS ExportKindId
                                       
                                       , COALESCE (ObjectBoolean_ExportJuridical_Auto.ValueData, FALSE) AS isAuto

                                  FROM Object AS Object_ExportJuridical
                                       -- Автоотправка
                                       LEFT JOIN ObjectBoolean AS ObjectBoolean_ExportJuridical_Auto
                                                               ON ObjectBoolean_ExportJuridical_Auto.ObjectId = Object_ExportJuridical.Id
                                                              AND ObjectBoolean_ExportJuridical_Auto.DescId   = zc_ObjectBoolean_ExportJuridical_Auto()
                                       -- Если есть кому отправлять
                                       INNER JOIN ObjectLink AS ObjectLink_ExportJuridical_ContactPerson
                                                             ON ObjectLink_ExportJuridical_ContactPerson.ObjectId = Object_ExportJuridical.Id
                                                            AND ObjectLink_ExportJuridical_ContactPerson.DescId = zc_ObjectLink_ExportJuridical_ContactPerson()
                                       INNER JOIN ObjectString AS ObjectString_ContactPersonMail
                                                               ON ObjectString_ContactPersonMail.ObjectId = ObjectLink_ExportJuridical_ContactPerson.ChildObjectId
                                                              AND ObjectString_ContactPersonMail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                              AND ObjectString_ContactPersonMail.ValueData <> ''
                                       -- Если есть откуда отправлять
                                       INNER JOIN ObjectLink AS ObjectLink_EmailKind
                                                             ON ObjectLink_EmailKind.ObjectId = Object_ExportJuridical.Id
                                                            AND ObjectLink_EmailKind.DescId = zc_ObjectLink_ExportJuridical_EmailKind()
                                                            AND ObjectLink_EmailKind.ChildObjectId > 0
                                       -- Если есть формат выгрузки
                                       INNER JOIN ObjectLink AS ObjectLink_ExportJuridical_ExportKind
                                                             ON ObjectLink_ExportJuridical_ExportKind.ObjectId = Object_ExportJuridical.Id
                                                            AND ObjectLink_ExportJuridical_ExportKind.DescId = zc_ObjectLink_ExportJuridical_ExportKind()
                                                            AND ObjectLink_ExportJuridical_ExportKind.ChildObjectId > 0

                                       LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_Contract
                                                            ON ObjectLink_ExportJuridical_Contract.ObjectId = Object_ExportJuridical.Id
                                                           AND ObjectLink_ExportJuridical_Contract.DescId = zc_ObjectLink_ExportJuridical_Contract()
                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                            ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_ExportJuridical_Contract.ChildObjectId
                                                           AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                       LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                                            ON ObjectLink_Contract_InfoMoney.ObjectId = ObjectLink_ExportJuridical_Contract.ChildObjectId
                                                           AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

                                       LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_Juridical
                                                            ON ObjectLink_ExportJuridical_Juridical.ObjectId = Object_ExportJuridical.Id
                                                           AND ObjectLink_ExportJuridical_Juridical.DescId = zc_ObjectLink_ExportJuridical_Juridical()
                                       LEFT JOIN ObjectLink AS ExportJuridical_Retail
                                                            ON ExportJuridical_Retail.ObjectId = Object_ExportJuridical.Id
                                                           AND ExportJuridical_Retail.DescId = zc_ObjectLink_ExportJuridical_Retail()
                                       LEFT JOIN ObjectLink AS ObjectLink_ExportJuridical_InfoMoney
                                                            ON ObjectLink_ExportJuridical_InfoMoney.ObjectId = Object_ExportJuridical.Id
                                                           AND ObjectLink_ExportJuridical_InfoMoney.DescId = zc_ObjectLink_ExportJuridical_InfoMoney()

                                  WHERE Object_ExportJuridical.DescId = zc_Object_ExportJuridical()
                                    AND Object_ExportJuridical.isErased = FALSE
                                 ) AS tmp
                                 LEFT JOIN Object ON Object.Id = tmp.ObjectId
                           )
       , tmpPartner_jur AS (-- из Юр. лиц
                            SELECT tmpList_all.*
                                 , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                            FROM tmpList_all
                                 INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = tmpList_all.ObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            WHERE tmpList_all.ObjectDescId = zc_Object_Juridical()
                           )
           , tmpPartner AS (-- из Юр. лиц
                            SELECT tmpPartner_jur.*
                            FROM tmpPartner_jur
                           UNION
                            -- из Торговой сети
                            SELECT tmpList_all.*
                                 , ObjectLink_Partner_Juridical.ObjectId AS PartnerId
                            FROM tmpList_all
                                 INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                       ON ObjectLink_Juridical_Retail.ChildObjectId = tmpList_all.ObjectId
                                                      AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                 INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ChildObjectId = ObjectLink_Juridical_Retail.ObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                 LEFT JOIN tmpPartner_jur ON tmpPartner_jur.PartnerId = ObjectLink_Partner_Juridical.ObjectId
                            WHERE tmpList_all.ObjectDescId = zc_Object_Retail()
                              AND tmpPartner_jur.PartnerId IS NULL
                           )

       SELECT
             tmpPartner.ExportKindId
           , Object_ExportKind.ObjectCode       AS ExportKindCode
           , Object_ExportKind.ValueData        AS ExportKindName

           , tmpPartner.ContactPersonMail

           , Object_Partner.Id                  AS PartnerId
           , Object_Partner.ObjectCode          AS PartnerCode
           , Object_Partner.ValueData           AS PartnerName
           , Object_Partner.isErased            AS isErased

           , tmpPartner.EmailKindId
           , Object_EmailKind.ObjectCode        AS EmailKindCode
           , Object_EmailKind.ValueData         AS EmailKindName

           , ObjectDesc.ItemName                AS ObjectDescName
           , Object.ObjectCode                  AS ObjectCode
           , Object.ValueData                   AS ObjectName

           , tmpPartner.ContractId
           , Object_Contract.ObjectCode         AS ContractCode
           , Object_Contract.ValueData          AS ContractName

           , tmpPartner.InfoMoneyId
           , Object_InfoMoney.ObjectCode        AS InfoMoneyCode
           , Object_InfoMoney.ValueData         AS InfoMoneyName

           , tmpPartner.Id
           , tmpPartner.Code
           , tmpPartner.Name
           
           , tmpPartner.isAuto :: Boolean       AS isAuto

       FROM tmpPartner
            LEFT JOIN Object AS Object_ExportKind ON Object_ExportKind.Id = tmpPartner.ExportKindId
            LEFT JOIN Object AS Object_Partner    ON Object_Partner.Id = tmpPartner.PartnerId
            LEFT JOIN Object AS Object_EmailKind  ON Object_EmailKind.Id = tmpPartner.EmailKindId

            LEFT JOIN Object     ON Object.Id = tmpPartner.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId

            LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id = tmpPartner.ContractId
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpPartner.InfoMoneyId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.16                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Object_ExportJuridical_list ()
