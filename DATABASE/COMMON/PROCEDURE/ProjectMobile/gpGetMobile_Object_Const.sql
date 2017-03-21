-- Function: gpGetMobile_Object_Const (TVarChar)

DROP FUNCTION IF EXISTS gpGetMobile_Object_Const (TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_Object_Const(
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (PaidKindId_First    Integer   -- Форма оплаты - БН
             , PaidKindName_First  TVarChar  -- Форма оплаты - НАЛ
             , PaidKindId_Second   Integer   -- Форма оплаты - НАЛ
             , PaidKindName_Second TVarChar  -- Форма оплаты - НАЛ
             , StatusId_UnComplete   Integer   -- Статус - Не проведен
             , StatusName_UnComplete TVarChar  -- Статус - Не проведен
             , StatusId_Complete     Integer   -- Статус - Проведен
             , StatusName_Complete   TVarChar  -- Статус - Проведен
             , StatusId_Erased     Integer   -- Статус - Удален
             , StatusName_Erased   TVarChar  -- Статус - Удален
             , UnitId              Integer   -- Подразделение - на какой склад будет оформляться заказ + какие остатки будем загружать из главной БД + и т.п.
             , UnitName            TVarChar  -- Подразделение
             , UnitId_ret          Integer   -- Подразделение Возврата - на какой склад будет оформляться возврат
             , UnitName_ret        TVarChar  -- Подразделение Возврата
             , CashId              Integer   -- Касса - используется если будет формироваться приход денег
             , CashName            TVarChar  -- Касса
             , MemberId            Integer   -- Физ. лицо
             , MemberName          TVarChar  -- Физ. лицо|информативно
             , PersonalId          Integer   -- Сотрудник
             , UserId              Integer   -- Пользователь
             , UserLogin           TVarChar  -- Логин
             , UserPassword        TVarChar  -- Пароль
             , WebService          TVarChar  -- Веб-сервис через который происходит коннект к основной БД
             -- , SyncDateIn          TDateTime -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
             -- , SyncDateOut         TDateTime -- Дата/время последней синхронизации - когда "успешно" выгружалась иходящая информация - заказы, возвраты и т.д
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
-- !!!ВРЕМЕННО - ДЛЯ ТЕСТА!!! - Волошина Е.А.
if inSession = '5' then  inSession :=  '140094'; end if;

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpPersonal AS (SELECT ObjectLink_User_Member.ChildObjectId      AS MemberId
                                 , Object_Member.ValueData                   AS MemberName
                                 , MAX (View_Personal.PersonalId) :: Integer AS PersonalId
                            FROM (SELECT 1) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                      ON ObjectLink_User_Member.ObjectId = vbUserId
                                                        AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                 LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                                 LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.MemberId = ObjectLink_User_Member.ChildObjectId
                            GROUP BY ObjectLink_User_Member.ChildObjectId
                                   , Object_Member.ValueData
                           )
       -- Результат
       SELECT Object_PaidKind_FirstForm.Id           AS PaidKindId_First
            , Object_PaidKind_FirstForm.ValueData    AS PaidKindName_First
            , Object_PaidKind_SecondForm.Id          AS PaidKindId_Second
            , Object_PaidKind_SecondForm.ValueData   AS PaidKindName_Second
           
            , Object_Status_Complete.Id              AS StatusId_Complete
            , Object_Status_Complete.ValueData       AS StatusName_Complete
            , Object_Status_UnComplete.Id            AS StatusId_UnComplete
            , Object_Status_UnComplete.ValueData     AS StatusName_UnComplete
            , Object_Status_Erased.Id                AS StatusId_Erased
            , Object_Status_Erased.ValueData         AS StatusName_Erased

            , Object_Unit.Id                         AS UnitId
            , Object_Unit.ValueData                  AS UnitName
            , Object_Unit_ret.Id                     AS UnitId_ret
            , Object_Unit_ret.ValueData              AS UnitName_ret
            , Object_Cash.Id                         AS CashId
            , Object_Cash.ValueData                  AS CashName

            , tmpPersonal.MemberId
            , tmpPersonal.MemberName
            , tmpPersonal.PersonalId

            , Object_User.Id               AS UserId
            , Object_User.ValueData        AS UserLogin
            , ObjectString_User_.ValueData AS UserPassword

            , REPLACE (LOWER (Object_ConnectParam.ValueData), '/project', '/projectmobile')::TVarChar AS WebService

            -- AS LastDateIn
            -- AS LastDateOut

       FROM tmpPersonal
            LEFT JOIN Object AS Object_PaidKind_FirstForm  ON Object_PaidKind_FirstForm.Id = zc_Enum_PaidKind_FirstForm()
            LEFT JOIN Object AS Object_PaidKind_SecondForm ON Object_PaidKind_SecondForm.Id = zc_Enum_PaidKind_SecondForm()

            LEFT JOIN Object AS Object_Status_Complete   ON Object_Status_Complete.Id   = zc_Enum_Status_Complete()
            LEFT JOIN Object AS Object_Status_UnComplete ON Object_Status_UnComplete.Id = zc_Enum_Status_UnComplete()
            LEFT JOIN Object AS Object_Status_Erased     ON Object_Status_Erased.Id     = zc_Enum_Status_Erased()

            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = 8459 -- Склад Реализации
            LEFT JOIN Object AS Object_Unit_ret ON Object_Unit_ret.Id = 8461 -- Склад Возвратов
            LEFT JOIN Object AS Object_Cash     ON Object_Cash.Id     = NULL

            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId
            LEFT JOIN ObjectString AS ObjectString_User_
                                   ON ObjectString_User_.ObjectId = Object_User.Id
                                  AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

            LEFT JOIN Object AS Object_ConnectParam ON Object_ConnectParam.Id = zc_Enum_GlobalConst_ConnectParam ()
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.02.17                                        *
*/

-- тест
-- SELECT * FROM gpGetMobile_Object_Const (inSession:= zfCalc_UserAdmin())
