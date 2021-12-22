-- Function: gpGet_Object_MemberMinus()

DROP FUNCTION IF EXISTS gpGet_Object_MemberMinus(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_MemberMinus(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MemberMinus(
    IN inId          Integer,       -- Основные средства
    IN inMaskId      Integer,       --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, ToShort TVarChar, INN_to TVarChar
             , BankAccountFromId Integer, BankAccountFromName TVarChar
             , BankAccountToId Integer, BankAccountToName TVarChar
             , DetailPayment TVarChar, BankAccountTo TVarChar
             , Number TVarChar
             , TotalSumm TFloat, Summ TFloat
             , Tax TFloat
             , isChild Boolean
             ) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MemberMinus());
   
   IF COALESCE (inId, 0) = 0 AND COALESCE (inMaskId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST ('' as TVarChar)  AS Name
           
           , CAST (0 as Integer)    AS FromId
           , CAST ('' as TVarChar)  AS FromName
           
           , CAST (0 as Integer)    AS ToId
           , CAST ('' as TVarChar)  AS ToName
           , CAST ('' as TVarChar)  AS ToShort
           , CAST ('' AS TVarChar)  AS INN_to
           
           , CAST (0 as Integer)    AS BankAccountFromId
           , CAST ('' as TVarChar)  AS BankAccountFromName

           , CAST (0 as Integer)    AS BankAccountToId
           , CAST ('' as TVarChar)  AS BankAccountToName

           , CAST ('' as TVarChar)  AS DetailPayment
           , CAST ('' as TVarChar)  AS BankAccountTo
           , CAST ('' as TVarChar)  AS Number
           
           , 0 :: TFloat            AS TotalSumm
           , 0 :: TFloat            AS Summ
           , 0 :: TFloat            AS Tax
           , FALSE ::Boolean        AS isChild
          ;
   ELSE
     RETURN QUERY 
     SELECT 
           CASE WHEN inMaskId <> 0 THEN 0  ELSE Object_MemberMinus.Id        END :: Integer  AS Id
         , CASE WHEN inMaskId <> 0 THEN '' ELSE Object_MemberMinus.ValueData END :: TVarChar AS Name
         
         , MemberMinus_From.Id                  AS FromId
         , MemberMinus_From.ValueData           AS FromName

         , Object_To.Id                         AS ToId
         , Object_To.ValueData                  AS ToName
         , ObjectString_ToShort.ValueData       AS ToShort
         , CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN ObjectHistory_JuridicalDetails_View.OKPO
                ELSE ObjectString_INN_to.ValueData
           END                                  AS INN_to

         , Object_BankAccountFrom.Id            AS BankAccountFromId
         , Object_BankAccountFrom.ValueData     AS BankAccountFromName

         , Object_BankAccountTo.Id              AS BankAccountToId
         , Object_BankAccountTo.ValueData       AS BankAccountToName

         , ObjectString_DetailPayment.ValueData AS DetailPayment
         , ObjectString_BankAccountTo.ValueData AS BankAccountTo

         , COALESCE (ObjectString_Number.ValueData,'')::TVarChar   AS Number

         , COALESCE (ObjectFloat_TotalSumm.ValueData, 0) :: TFloat AS TotalSumm
         , COALESCE (ObjectFloat_Summ.ValueData, 0)      :: TFloat AS Summ
         , COALESCE (ObjectFloat_Tax.ValueData, 0)       :: TFloat AS Tax

         , COALESCE (ObjectBoolean_Child.ValueData, FALSE) :: Boolean AS isChild
         
     FROM OBJECT AS Object_MemberMinus
          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_From
                               ON ObjectLink_MemberMinus_From.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_From.DescId = zc_ObjectLink_MemberMinus_From()
          LEFT JOIN Object AS MemberMinus_From ON MemberMinus_From.Id = ObjectLink_MemberMinus_From.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_To
                               ON ObjectLink_MemberMinus_To.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_To.DescId = zc_ObjectLink_MemberMinus_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_MemberMinus_To.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountFrom
                               ON ObjectLink_MemberMinus_BankAccountFrom.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_BankAccountFrom.DescId = zc_ObjectLink_MemberMinus_BankAccountFrom()
          LEFT JOIN Object AS Object_BankAccountFrom ON Object_BankAccountFrom.Id = ObjectLink_MemberMinus_BankAccountFrom.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_MemberMinus_BankAccountTo
                               ON ObjectLink_MemberMinus_BankAccountTo.ObjectId = Object_MemberMinus.Id
                              AND ObjectLink_MemberMinus_BankAccountTo.DescId = zc_ObjectLink_MemberMinus_BankAccountTo()
          LEFT JOIN Object AS Object_BankAccountTo ON Object_BankAccountTo.Id = ObjectLink_MemberMinus_BankAccountTo.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Child
                                  ON ObjectBoolean_Child.ObjectId = Object_MemberMinus.Id
                                 AND ObjectBoolean_Child.DescId = zc_ObjectBoolean_MemberMinus_Child()

          LEFT JOIN ObjectString AS ObjectString_Number
                                 ON ObjectString_Number.ObjectId = Object_MemberMinus.Id
                                AND ObjectString_Number.DescId = zc_ObjectString_MemberMinus_Number()

          LEFT JOIN ObjectString AS ObjectString_ToShort
                                 ON ObjectString_ToShort.ObjectId = Object_MemberMinus.Id
                                AND ObjectString_ToShort.DescId = zc_ObjectString_MemberMinus_ToShort()

          LEFT JOIN ObjectString AS ObjectString_DetailPayment
                                 ON ObjectString_DetailPayment.ObjectId = Object_MemberMinus.Id
                                AND ObjectString_DetailPayment.DescId = zc_ObjectString_MemberMinus_DetailPayment()

          LEFT JOIN ObjectString AS ObjectString_BankAccountTo
                                 ON ObjectString_BankAccountTo.ObjectId = Object_MemberMinus.Id
                                AND ObjectString_BankAccountTo.DescId = zc_ObjectString_MemberMinus_BankAccountTo()

          LEFT JOIN ObjectString AS ObjectString_INN_to
                                 ON ObjectString_INN_to.ObjectId = Object_To.Id
                                AND ObjectString_INN_to.DescId IN (zc_ObjectString_MemberExternal_INN(), zc_ObjectString_Member_INN())
                                AND Object_To.DescId = zc_Object_MemberExternal()
          LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id
                                                       AND Object_To.DescId = zc_Object_Juridical()

          LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                ON ObjectFloat_TotalSumm.ObjectId = Object_MemberMinus.Id
                               AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_MemberMinus_TotalSumm()

          LEFT JOIN ObjectFloat AS ObjectFloat_Summ
                                ON ObjectFloat_Summ.ObjectId = Object_MemberMinus.Id
                               AND ObjectFloat_Summ.DescId = zc_ObjectFloat_MemberMinus_Summ()

          LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                                ON ObjectFloat_Tax.ObjectId = Object_MemberMinus.Id
                               AND ObjectFloat_Tax.DescId = zc_ObjectFloat_MemberMinus_Tax()
       WHERE Object_MemberMinus.Id = CASE WHEN COALESCE (inId, 0) = 0 THEN inMaskId ELSE inId END;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.12.21         *
 20.11.20
 04.09.20         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MemberMinus(0, 0,'2')