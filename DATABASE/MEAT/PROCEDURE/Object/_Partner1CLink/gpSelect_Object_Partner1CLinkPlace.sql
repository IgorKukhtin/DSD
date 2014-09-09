-- Function: gpSelect_Object_Partner1CLinkPlace()

DROP FUNCTION IF EXISTS gpSelect_Object_Partner1CLinkPlace (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Partner1CLinkPlace(
    IN inJuridicalId       Integer  , 
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               Address TVarChar,
               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupCode Integer, JuridicalGroupName TVarChar, 
               OKPO TVarChar,
               ItemName TVarChar,
               isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Partner1CLinkPlace());

   RETURN QUERY 
     SELECT 
           Object_Partner.Id               AS Id
         , Object_Partner.ObjectCode       AS Code
         , Object_Partner.ValueData        AS Name

         , ObjectString_Address.ValueData  AS Address

         , Object_Juridical.Id              AS JuridicalId
         , Object_Juridical.ObjectCode      AS JuridicalCode
         , Object_Juridical.ValueData       AS JuridicalName
         , Object_JuridicalGroup.ObjectCode AS JuridicalGroupCode
         , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
         , ObjectHistory_JuridicalDetails_View.OKPO

         , ObjectDesc.ItemName
         , Object_Partner.isErased   AS isErased
         
     FROM Object AS Object_Partner
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Partner.DescId
         LEFT JOIN ObjectString AS ObjectString_Address
                                ON ObjectString_Address.ObjectId = Object_Partner.Id
                               AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id 
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
         
         LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                              ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id
                             AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
         LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

         LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

    WHERE Object_Partner.DescId = zc_Object_Partner() AND (inJuridicalId = 0 OR inJuridicalId = ObjectLink_Partner_Juridical.ChildObjectId)

   UNION ALL
     -- УП статьи
     SELECT 
           InfoMoneyId              AS Id
         , InfoMoneyCode            AS Code
         , InfoMoneyName_all        AS Name
         
         , NULL :: TVarChar           AS Address

         , 0 :: Integer               AS JuridicalId
         , NULL :: Integer            AS JuridicalCode
         , NULL :: TVarChar           AS JuridicalName
         , InfoMoneyGroupCode         AS JuridicalGroupCode
         , InfoMoneyGroupName         AS JuridicalGroupName
         , NULL :: TVarChar           AS OKPO

         , ObjectDesc.ItemName
         , Object_InfoMoney_View.isErased

     FROM Object_InfoMoney_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_InfoMoney()
     WHERE InfoMoneyId = zc_Enum_InfoMoney_40801() -- Внутренний оборот

   UNION ALL
     -- Подразделения
     SELECT 
           Object_Unit_View.Id        AS Id
         , Object_Unit_View.Code      AS Code
         , Object_Unit_View.Name      AS Name
         
         , NULL :: TVarChar           AS Address

         , 0 :: Integer               AS JuridicalId
         , NULL :: Integer            AS JuridicalCode
         , NULL :: TVarChar           AS JuridicalName
         , NULL :: Integer            AS JuridicalGroupCode
         , NULL :: TVarChar           AS JuridicalGroupName
         , NULL :: TVarChar           AS OKPO

         , ObjectDesc.ItemName
         , Object_Unit_View.isErased

     FROM Object_Unit_View
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = zc_Object_Unit()

   UNION ALL
     -- Статьи списания
     SELECT 
           Object_ArticleLoss.Id           AS Id
         , Object_ArticleLoss.ObjectCode   AS Code
         , Object_ArticleLoss.ValueData    AS Name
         
         , ('(' || View_ProfitLossDirection.ProfitLossDirectionCode :: TVarChar || ') ' || View_ProfitLossDirection.ProfitLossDirectionName) :: TVarChar AS Address

         , 0 :: Integer               AS JuridicalId
         , NULL :: Integer            AS JuridicalCode
         , NULL :: TVarChar           AS JuridicalName
         , View_ProfitLossDirection.ProfitLossGroupCode AS JuridicalGroupCode
         , View_ProfitLossDirection.ProfitLossGroupName AS JuridicalGroupName
         , NULL :: TVarChar           AS OKPO

         , ObjectDesc.ItemName
         , Object_ArticleLoss.isErased

     FROM Object AS Object_ArticleLoss
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_ArticleLoss.DescId
          LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                               ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                              AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
          LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId
     WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss()

   UNION ALL
     -- Сотрудники Филиалов
     SELECT 
           Object_Personal.Id
         , Object_Personal.ObjectCode AS Code
         , Object_Personal.ValueData  AS Name
         
         , Object_Position.ValueData AS Address

         , 0 :: Integer               AS JuridicalId
         , NULL :: Integer            AS JuridicalCode
         , NULL :: TVarChar           AS JuridicalName
         , Object_Unit.ObjectCode     AS JuridicalGroupCode
         , Object_Unit.ValueData      AS JuridicalGroupName
         , ObjectString_INN.ValueData AS OKPO

         , ObjectDesc.ItemName
         , Object_Personal.isErased   AS isErased

     FROM (SELECT ObjectLink_Personal_Unit.ObjectId                        AS PersonalId
                , ObjectLink_Personal_Member.ChildObjectId                 AS MemberId
                , ObjectLink_Personal_Unit.ChildObjectId                   AS UnitId
                , COALESCE (ObjectLink_Personal_Position.ChildObjectId, 0) AS PositionId
           FROM ObjectLink AS ObjectLink_Unit_Branch
                INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                      ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                     AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                     ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Personal_Unit.ObjectId
                                    AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Position()
                LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                     ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Unit.ObjectId
                                    AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
           WHERE ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
             AND ObjectLink_Unit_Branch.ChildObjectId <> zc_Branch_Basis()
             AND ObjectLink_Unit_Branch.ChildObjectId <> 0
          ) AS tmpPersonal
          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = tmpPersonal.PersonalId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Personal.DescId
          LEFT JOIN ObjectString AS ObjectString_INN
                                 ON ObjectString_INN.ObjectId = tmpPersonal.MemberId 
                                AND ObjectString_INN.DescId = zc_ObjectString_Member_INN()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpPersonal.PositionId
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Partner1CLinkPlace (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.09.14                                        * Member -> Personal
 01.09.14                                        * add ItemName
 27.08.14                                        * add Object_Unit_View
 24.08.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Partner1CLinkPlace (inJuridicalId:= 0, inSession:= zfCalc_UserAdmin())
