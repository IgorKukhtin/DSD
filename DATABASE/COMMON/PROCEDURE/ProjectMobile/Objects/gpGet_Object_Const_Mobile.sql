-- Function: gpGet_Object_Const_Mobile (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Const_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Const_Mobile(
     IN inMemberId       Integer  , -- физ.лицо
     IN inSession        TVarChar   -- сессия пользователя
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
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE calcUserId Integer;
   DECLARE calcSession TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION 'Ошибка.Не достаточно прав доступа.'; 
     END IF;

     calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar) 
                     FROM ObjectLink AS ObjectLink_User_Member
                     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       AND ObjectLink_User_Member.ChildObjectId = vbMemberId);

     calcUserId:= lpGetUserBySession (calcSession);

     -- Результат
     RETURN QUERY
       -- Результат
       SELECT tmpMobileConst.PaidKindId_First
            , tmpMobileConst.PaidKindName_First
            , tmpMobileConst.PaidKindId_Second
            , tmpMobileConst.PaidKindName_Second
           
            , tmpMobileConst.StatusId_Complete
            , tmpMobileConst.StatusName_Complete
            , tmpMobileConst.StatusId_UnComplete
            , tmpMobileConst.StatusName_UnComplete
            , tmpMobileConst.StatusId_Erased
            , tmpMobileConst.StatusName_Erased

            , tmpMobileConst.UnitId
            , tmpMobileConst.UnitName
            , tmpMobileConst.UnitId_ret
            , tmpMobileConst.UnitName_ret
            , tmpMobileConst.CashId
            , tmpMobileConst.CashName

            , tmpPersonal.MemberId
            , tmpPersonal.MemberName
            , tmpPersonal.PersonalId

            , Object_User.Id               AS UserId
            , Object_User.ValueData        AS UserLogin
            , ObjectString_User_.ValueData AS UserPassword

            , Object_ConnectParam.ValueData AS WebService

       FROM gpGetMobile_Object_Const (calcUserId) AS tmpMobileConst
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
-- SELECT * FROM gpGet_Object_Const_Mobile (inSession:= zfCalc_UserAdmin())
