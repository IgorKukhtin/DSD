-- View: _bi_Guide_ArticleLoss_View

 DROP VIEW IF EXISTS _bi_Guide_ArticleLoss_View;

-- Справочник Авто
/*
-- Названия
Id
Code
Name
-- Признак "Удален да/нет"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_ArticleLoss_View
AS
      SELECT Object_ArticleLoss.Id           AS Id
           , Object_ArticleLoss.ObjectCode   AS Code
           , Object_ArticleLoss.ValueData    AS Name
           , Object_ArticleLoss.isErased     AS isErased

           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName

           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName

           , View_ProfitLossDirection.ProfitLossGroupName

           , View_ProfitLossDirection.ProfitLossDirectionName

           , Object_Business.ValueData       AS BusinessName
           , Object_Branch.ValueData         AS BranchName

           , ObjectString_Comment.ValueData  AS Comment

       FROM Object AS Object_ArticleLoss
            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_InfoMoney
                                 ON ObjectLink_ArticleLoss_InfoMoney.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_InfoMoney.DescId = zc_ObjectLink_ArticleLoss_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_ArticleLoss_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_ProfitLossDirection
                                 ON ObjectLink_ArticleLoss_ProfitLossDirection.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_ProfitLossDirection.DescId = zc_ObjectLink_ArticleLoss_ProfitLossDirection()
            LEFT JOIN Object_ProfitLossDirection_View AS View_ProfitLossDirection ON View_ProfitLossDirection.ProfitLossDirectionId = ObjectLink_ArticleLoss_ProfitLossDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_Business
                                 ON ObjectLink_ArticleLoss_Business.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_Business.DescId = zc_ObjectLink_ArticleLoss_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_ArticleLoss_Business.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ArticleLoss_Branch
                                 ON ObjectLink_ArticleLoss_Branch.ObjectId = Object_ArticleLoss.Id
                                AND ObjectLink_ArticleLoss_Branch.DescId = zc_ObjectLink_ArticleLoss_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_ArticleLoss_Branch.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_ArticleLoss.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_ArticleLoss_Comment()

       WHERE Object_ArticleLoss.DescId = zc_Object_ArticleLoss()
      ;

ALTER TABLE _bi_Guide_ArticleLoss_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_ArticleLoss_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_ArticleLoss_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_ArticleLoss_View
