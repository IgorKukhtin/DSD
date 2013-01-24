/*
  процедура выборки данных объекта <Пользователь>
*/


   /* если есть такая процедура - удалить ее */
   IF object_id('gpGetUser') IS NOT NULL 
     DROP PROCEDURE gpGetUser
   GO


/*-------------------------------------------------------------------------------*/

CREATE PROCEDURE gpGetUser

@inId                          Integer   ,         /* ключ объекта <Пользователь> */
@ioListProcedure               TNVarChar OUTPUT,   /* стек процедур       */
@ioListErrorCode               TNVarChar OUTPUT,   /* стек кодов ошибок   */
@inSession                     TVarChar            /* сессия      */

/*  ВОЗВРАЩАЕМЫЙ НАБОР

    Id                            ключ объекта <Пользователь>
    Code                          главный код объекта <Пользователь>
    Name                          главное значение объекта <Пользователь>
    Login                         свойство <логин пользователя>
    Password                      свойство <пароль пользователя>
    UserGroupId                   ключ объекта <Группа пользователей>
    UserGroupCode                 главный код объекта <Группа пользователей>
    UserGroupName                 главное значение объекта <Группа пользователей>
    isErased                      признак удаления для объекта <Пользователь>

*/

/*-------------------------------------------------------------------------------*/

AS
BEGIN

  DECLARE @OperUserId            integer     /* пользователь проводящий операцию */
  DECLARE @CurrentOperationCode  TVarChar    /* код текущей операции */
  DECLARE @SysErrorCode   Integer     /* код системной ошибки */
  DECLARE @SysRowCount    Integer     /* код системной ошибки */
  DECLARE @_UserErrorCode Integer     /* код ошибки */
  DECLARE @_Code          TVarChar    /* код внутр. идентификатора */
  DECLARE @_procName      TVarChar    /* название текущей процедуры или функции для фомирования стека вызовов при ошибке */
      SET @_procName='gpGetUser'

  DECLARE @zc_ObjectUser Integer SET @zc_ObjectUser =  dbo.lfGetObjectDescIdFromCode(dbo.zc_ObjectUser())

  DECLARE @zc_ObjectStringUserLogin Integer SET @zc_ObjectStringUserLogin = dbo.lfGetObjectStringDescIdFromCode(dbo.zc_ObjectStringUserLogin())
  DECLARE @zc_ObjectStringUserPassword Integer SET @zc_ObjectStringUserPassword = dbo.lfGetObjectStringDescIdFromCode(dbo.zc_ObjectStringUserPassword())
  DECLARE @zc_ObjectUser_LinkUserGroup Integer SET @zc_ObjectUser_LinkUserGroup = dbo.lfGetObjectLinkDescIdFromCode(dbo.zc_ObjectUser_LinkUserGroup())


      /* Проверка сессии и определение прав пользователя на вызов текущей процедуры */
      /*  */
      EXECUTE lpCheckUserRights  @OperUserId OUTPUT,  @inSession , @CurrentOperationCode ,@ioListProcedure OUTPUT, @ioListErrorCode OUTPUT

      SET @SysErrorCode=@@ERROR 
      /* проверка ошибки */ 
      IF @SysErrorCode<>0 OR ISNULL(@ioListErrorCode, '') <> '' BEGIN 
        SET @_UserErrorCode=dbo.zc_msgNotRightsForGetUser() 
        EXECUTE lpAddErrorStack @ioListProcedure OUTPUT, @ioListErrorCode OUTPUT ,@_ProcName ,@_UserErrorCode, @SysErrorCode 
        RETURN /* !!! выход при ошибке !!! */
      END

  SELECT
     Object.Id
   , Object.ObjectCode AS Code
   , Object.ValueData AS Name

   , ObjectStringUserLogin.ValueData AS Login
   , ObjectStringUserPassword.ValueData AS Password
   , ObjectUser_LinkUserGroup.Id AS UserGroupId
   , ObjectUser_LinkUserGroup.ObjectCode AS UserGroupCode
   , ObjectUser_LinkUserGroup.ValueData AS UserGroupName
   , Object.isErased
   FROM Object

  LEFT JOIN ObjectString AS ObjectStringUserLogin ON ObjectStringUserLogin.DescId = @zc_ObjectStringUserLogin AND ObjectStringUserLogin.ObjectId = Object.Id
  LEFT JOIN ObjectString AS ObjectStringUserPassword ON ObjectStringUserPassword.DescId = @zc_ObjectStringUserPassword AND ObjectStringUserPassword.ObjectId = Object.Id
  LEFT JOIN ObjectLink AS ObjectLink_User_LinkUserGroup ON ObjectLink_User_LinkUserGroup.ParentObjectId = Object.Id AND ObjectLink_User_LinkUserGroup.DescId = @zc_ObjectUser_LinkUserGroup
  LEFT JOIN Object AS ObjectUser_LinkUserGroup ON ObjectUser_LinkUserGroup.Id = ObjectLink_User_LinkUserGroup.ChildObjectId
  WHERE Object.DescId = @zc_ObjectUser AND Object.Id = @inId

END
GO

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
23.10.02 11:03 
*/
