-- Function: gpGet_UserJuridicalBankAccount()

DROP FUNCTION IF EXISTS gpGet_UserJuridicalBankAccount (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UserJuridicalBankAccount(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE(JuridicalBasisId integer
            , JuridicalBasisName TVarChar
            )
AS
$BODY$
     DECLARE vbUserId      Integer;
     DECLARE vbMemberId    Integer;
     DECLARE vbJuridicalId Integer;
BEGIN

     vbUserId:= lpGetUserBySession (inSession);
     
     -- находим Физ лицо по пользователю
     vbMemberId := (SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
                    FROM ObjectLink AS ObjectLink_User_Member
                    WHERE ObjectLink_User_Member.ObjectId = vbUserId
                      AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                    );

     CREATE TEMP TABLE _tmpJuridical (JuridicalId Integer) ON COMMIT DROP;
        INSERT INTO _tmpJuridical (JuridicalId)
              SELECT CASE WHEN COALESCE (ObjectBoolean_All.ValueData, FALSE) = TRUE THEN zc_Juridical_Basis() ELSE BankAccount_Juridical.ChildObjectId END AS JuridicalId
              FROM ObjectLink AS ObjectLink_MemberBankAccount_Member
                  INNER JOIN Object AS Object_MemberBankAccount
                                    ON Object_MemberBankAccount.Id = ObjectLink_MemberBankAccount_Member.ObjectId
                                   AND Object_MemberBankAccount.DescId = zc_Object_MemberBankAccount()
                                   AND Object_MemberBankAccount.isErased = FALSE
                  LEFT JOIN ObjectBoolean AS ObjectBoolean_All 
                                          ON ObjectBoolean_All.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                         AND ObjectBoolean_All.DescId = zc_ObjectBoolean_MemberBankAccount_All()
                                         AND COALESCE (ObjectBoolean_All.ValueData, FALSE) = FALSE
       
                  LEFT JOIN ObjectLink AS ObjectLink_MemberBankAccount_BankAccount
                                       ON ObjectLink_MemberBankAccount_BankAccount.ObjectId = ObjectLink_MemberBankAccount_Member.ObjectId
                                      AND ObjectLink_MemberBankAccount_BankAccount.DescId = zc_ObjectLink_MemberBankAccount_BankAccount()
       
                  LEFT JOIN ObjectLink AS BankAccount_Juridical
                                       ON BankAccount_Juridical.ObjectId = ObjectLink_MemberBankAccount_BankAccount.ChildObjectId
                                      AND BankAccount_Juridical.DescId = zc_ObjectLink_BankAccount_Juridical()
         
              WHERE ObjectLink_MemberBankAccount_Member.DescId = zc_ObjectLink_MemberBankAccount_Member()
                AND ObjectLink_MemberBankAccount_Member.ChildObjectId = vbMemberId;
     
     IF (SELECT COUNT (*) FROM _tmpJuridical) = 1
     THEN
         vbJuridicalId := (SELECT _tmpJuridical.JuridicalId FROM _tmpJuridical);
     ELSE
         IF EXISTS (SELECT 1 FROM _tmpJuridical WHERE _tmpJuridical.JuridicalId = zc_Juridical_Basis())
         THEN
             vbJuridicalId := zc_Juridical_Basis();
         ELSE 
             vbJuridicalId := (SELECT _tmpJuridical.JuridicalId FROM _tmpJuridical LIMIT 1);
         END IF;
     END IF;


     RETURN QUERY
      SELECT Object.Id        AS JuridicalBasisId
           , Object.ValueData AS JuridicalBasisName
      FROM Object 
      WHERE Object.Id = vbJuridicalId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.03.20         *
*/

-- тест
-- SELECT * FROM gpGet_UserJuridicalBankAccount (inSession := '2')