-- Function: gpInsertUpdate_Movement_QualityDoc (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityDoc (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityDoc(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovementId_Sale     Integer   , -- 
    IN inInvNumberMark       TVarChar  , -- 
    IN inCarId               Integer   , -- Автомобиль
    IN inCarTrailerId        Integer   , -- Автомобиль (прицеп)
    IN inPersonalDriverId    Integer   , -- Сотрудник (водитель)
    IN inPersonalDriverName  TVarChar  , -- Сотрудник (водитель)
    IN inRouteId             Integer   , -- 
    IN inMemberId1           Integer   , -- отримав водій/експедитор
    IN inMemberName1         TVarChar  , -- отримав водій/експедитор
    IN inMemberId2           Integer   , -- Бухгалтер (відповідальна особа вантажовідправника)
    IN inMemberName2         TVarChar  , -- Бухгалтер (відповідальна особа вантажовідправника)
    IN inMemberId3           Integer   , -- Відпуск дозволив
    IN inMemberName3         TVarChar  , -- Відпуск дозволив
    IN inMemberId4           Integer   , -- Здав (відповідальна особа вантажовідправника)
    IN inMemberName4         TVarChar  , -- Здав (відповідальна особа вантажовідправника)
    IN inMemberId5           Integer   , -- Прийняв водій/експедитор
    IN inMemberName5         TVarChar  , -- Прийняв водій/експедитор
    IN inMemberId6           Integer   , -- Здав водій/експедитор
    IN inMemberName6         TVarChar  , -- Здав водій/експедитор
    IN inMemberId7           Integer   , -- Прийняв (відповідальна особа вантажоодержувача) 
    IN inMemberName7         TVarChar  , -- Прийняв (відповідальна особа вантажоодержувача) 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityDoc());
     vbUserId:= lpGetUserBySession (inSession);


     -- нашли <Сотрудник (водитель)>
     inPersonalDriverId:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inPersonalDriverName) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inPersonalDriverId, 0) = 0 AND TRIM (inPersonalDriverName) <> ''
     THEN
         -- создание
         inPersonalDriverId:= lpInsertUpdate_Object_MemberExternal (ioId    := inPersonalDriverId
                                                                  , inCode  := 0
                                                                  , inName  := inPersonalDriverName
                                                                  , inUserId:= vbUserId
                                                                   );
     END IF;

     -- нашли <отримав водій/експедитор>
     inMemberId1:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName1) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId1, 0) = 0 AND TRIM (inMemberName1) <> ''
     THEN
         -- создание
         inMemberId1:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId1
                                                           , inCode  := 0
                                                           , inName  := inMemberName1
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- нашли <Бухгалтер (відповідальна особа вантажовідправника)>
     inMemberId2:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName2) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId2, 0) = 0 AND TRIM (inMemberName2) <> ''
     THEN
         -- создание
         inMemberId2:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId2
                                                           , inCode  := 0
                                                           , inName  := inMemberName2
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- нашли <Відпуск дозволив>
     inMemberId3:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName3) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId3, 0) = 0 AND TRIM (inMemberName3) <> ''
     THEN
         -- создание
         inMemberId3:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId3
                                                           , inCode  := 0
                                                           , inName  := inMemberName3
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- нашли <Здав (відповідальна особа вантажовідправника)>
     inMemberId4:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName4) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId4, 0) = 0 AND TRIM (inMemberName4) <> ''
     THEN
         -- создание
         inMemberId4:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId4
                                                           , inCode  := 0
                                                           , inName  := inMemberName4
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- нашли <Прийняв водій/експедитор>
     inMemberId5:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName5) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId5, 0) = 0 AND TRIM (inMemberName5) <> ''
     THEN
         -- создание
         inMemberId5:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId5
                                                           , inCode  := 0
                                                           , inName  := inMemberName5
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- нашли <Здав водій/експедитор>
     inMemberId6:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName6) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId6, 0) = 0 AND TRIM (inMemberName6) <> ''
     THEN
         -- создание
         inMemberId6:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId6
                                                           , inCode  := 0
                                                           , inName  := inMemberName6
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- нашли <Прийняв (відповідальна особа вантажоодержувача)>
     inMemberId7:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName7) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId7, 0) = 0 AND TRIM (inMemberName7) <> ''
     THEN
         -- создание
         inMemberId7:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId7
                                                           , inCode  := 0
                                                           , inName  := inMemberName7
                                                           , inUserId:= vbUserId
                                                            );
     END IF;


     -- сохранили <Документ>
     ioId:= lpInsertUpdate_Movement_QualityDoc (ioId              := ioId
                                                  , inInvNumber       := inInvNumber
                                                  , inOperDate        := inOperDate
                                                  , inMovementId_Sale := inMovementId_Sale
                                                  , inInvNumberMark   := inInvNumberMark
                                                  , inCarId           := inCarId
                                                  , inCarTrailerId    := inCarTrailerId
                                                  , inPersonalDriverId:= inPersonalDriverId
                                                  , inRouteId         := inRouteId
                                                  , inMemberId1       := inMemberId1
                                                  , inMemberId2       := inMemberId2
                                                  , inMemberId3       := inMemberId3
                                                  , inMemberId4       := inMemberId4
                                                  , inMemberId5       := inMemberId5
                                                  , inMemberId6       := inMemberId6
                                                  , inMemberId7       := inMemberId7
                                                  , inUserId          := vbUserId
                                                   );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.03.15                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
