-- Function: gpInsert_EDIFiles()

DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc(TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc(Integer, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_IsElectronFromMedoc (Integer, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IsElectronFromMedoc(
   OUT outId                 Integer    ,
--    IN SEND_DPA TVarChar   , -- 
--    IN FormCode TVarChar   , -- 
    IN inMedocCode           Integer    ,
    IN inFromINN             TVarChar   , -- ИНН от кого
    IN inToINN               TVarChar   , -- ИНН кому
    IN inInvNumber           TVarChar   , -- Номер
    IN inOperDate            TDateTime  , -- Дата
    IN inInvNumberBranch     TVarChar   , -- Филиал
    IN inInvNumberRegistered TVarChar   , -- Номер
    IN inDateRegistered      TDateTime  , -- Дата
    IN inDocKind             TVarChar   , -- Тип документа
    IN inContract            TVarChar   , -- Договор
    IN inTotalSumm           TFloat     , -- Сумма документа
    IN inMedocCharCode       TVarChar   , -- 
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbIsBranch_Medoc boolean;
   DECLARE vbAccessKey Integer;
   DECLARE vbMedocId Integer;
BEGIN
/*
CREATE TABLE _Medoc(
  inMedocCode           Integer    NULL,
  inFromINN             TVarChar   NULL, -- ИНН от кого
  inToINN               TVarChar   NULL, -- ИНН кому
  inInvNumber           TVarChar   NULL, -- Номер
  inOperDate            TDateTime  NULL, -- Дата
  inInvNumberBranch     TVarChar   NULL, -- Филиал
  inInvNumberRegistered TVarChar   NULL, -- Номер
  inDateRegistered      TDateTime  NULL, -- Дата
  inDocKind             TVarChar   NULL, -- Тип документа
  inContract            TVarChar   NULL, -- Договор
  inTotalSumm           TFloat     NULL -- Сумма документа
);
-- delete from _Medoc;
insert into _Medoc(
    SEND_DPA    , -- ИНН от кого
    FormCode , -- ИНН от кого
  inMedocCode           ,
  inFromINN             ,
  inToINN               ,
  inInvNumber           ,
  inOperDate            ,
  inInvNumberBranch     ,
  inInvNumberRegistered ,
  inDateRegistered      ,
  inDocKind             ,
  inContract            ,
  inTotalSumm           )
select   
    SEND_DPA ,
    FormCode ,
inMedocCode           ,
  inFromINN             ,
  inToINN               ,
  inInvNumber           ,
  inOperDate            ,
  inInvNumberBranch     ,
  inInvNumberRegistered ,
  inDateRegistered      ,
  inDocKind             ,
  inContract            ,
  inTotalSumm           ;
return;
*/
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDI());
    vbUserId:= lpGetUserBySession(inSession);

   CASE WHEN inInvNumberBranch  = '1' AND inOperDate < '01.11.2015' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentKharkov();
        WHEN inInvNumberBranch  = '2' AND inOperDate < '01.01.2016' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentKiev();
        WHEN inInvNumberBranch  = '5' AND inOperDate < '01.11.2015' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentNikolaev();
        WHEN inInvNumberBranch  = '8' AND inOperDate < '01.11.2015' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentKrRog();
        WHEN inInvNumberBranch  = '9' AND inOperDate < '01.11.2015' THEN vbAccessKey := zc_Enum_Process_AccessKey_DocumentCherkassi();
        ELSE  vbAccessKey := 0;
   END CASE;


   -- Нашли ключ Медок 
   SELECT Movement_Medoc_View.Id
          INTO vbMedocId 
   FROM Movement_Medoc_View 
   WHERE zfConvert_StringToNumber(InvNumber) = inMedocCode AND InvNumberBranch = inInvNumberBranch;

/*
 IF TRIM (inInvNumber) = '235'
 then 
     RAISE EXCEPTION '%   %   %   %', inInvNumberRegistered, vbMedocId, inInvNumberBranch, vbAccessKey;
 end if;
*/
-- IF TRIM (inInvNumberRegistered) = '9159204066'
-- then 
       -- INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       --    SELECT 5, CURRENT_TIMESTAMP, 5, inInvNumberRegistered || ';' || vbMedocId || ';' || vbAccessKey, true;
--     RAISE EXCEPTION '"%" %   %', inInvNumberRegistered, vbMedocId, vbAccessKey;
-- end if;

   -- Если ключ пустой, то добавили новый ключ МЕДОК
   IF COALESCE (vbMedocId, 0) = 0 OR (inInvNumberBranch  = '2' AND inOperDate < '01.12.2015') -- OR (vbAccessKey = zc_Enum_Process_AccessKey_DocumentKiev() AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMedocId AND Movement.ParentId IS NULL))
   THEN 
      -- добавили новый документ МЕДОК
      vbMedocId := lpInsertUpdate_Movement_Medoc(vbMedocId, inMedocCode, inInvNumber, inOperDate,
                           inFromINN, inToINN, inInvNumberBranch, inInvNumberRegistered, inDateRegistered, inDocKind, inContract, 
                           inTotalSumm, vbUserId);

      -- !!!если приход, то вышли!!!
      IF (SELECT Movement_Medoc_View.isIncome 
            FROM Movement_Medoc_View WHERE Movement_Medoc_View.Id = vbMedocId) THEN 
         outId := 0;   	
         RETURN;
      END IF;

      -- Если это филиал, то добавили документ
      IF vbAccessKey <> 0 THEN 
         IF inDocKind = 'Tax' THEN
            SELECT JuridicalId INTO vbFromId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inFromINN;
            SELECT JuridicalId INTO vbToId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inToINN;
            vbMovementId := lpInsert_Movement_TaxMedoc(inInvNumber, inInvNumberBranch, 
                                 inOperDate, 20::TFloat, vbFromId, vbToId, inContract, vbUserId);                       
            update Movement set AccessKeyId = vbAccessKey where Id = vbMovementId;
            outId := vbMovementId;
            UPDATE Movement SET ParentId = vbMovementId WHERE Id = vbMedocId;
         ELSE
            SELECT JuridicalId INTO vbToId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inFromINN;
            SELECT JuridicalId INTO vbFromId FROM ObjectHistory_JuridicalDetails_View WHERE ObjectHistory_JuridicalDetails_View.INN = inToINN;
            vbMovementId := lpInsert_Movement_TaxCorrectiveMedoc(inInvNumber, inInvNumberBranch, 
                                  inOperDate, 20::TFloat, vbFromId, vbToId, inContract, vbUserId);
            update Movement set AccessKeyId = vbAccessKey where Id = vbMovementId;
            outId := vbMovementId;
            UPDATE Movement SET ParentId = vbMovementId WHERE Id = vbMedocId;
         END IF;
      END IF;
   ELSE
      -- Заапдейтили
      vbMedocId := lpInsertUpdate_Movement_Medoc(vbMedocId, inMedocCode, inInvNumber, inOperDate,
                           inFromINN, inToINN, inInvNumberBranch, inInvNumberRegistered, inDateRegistered, inDocKind, inContract, 
                           inTotalSumm, vbUserId);
   END IF;

   -- Если это Днепр или Запорожье (вносят сами)
   IF vbAccessKey = 0 THEN 
      IF inDocKind = 'Tax' THEN
             vbMovementId:= (WITH tmp AS (SELECT Movement.Id, Movement.OperDate
                                          FROM Movement 
                                               LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                          WHERE MovementString_InvNumberPartner.ValueData = inInvNumber 
                                            AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_Tax()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         )
                             SELECT Movement.Id
                             FROM tmp AS Movement
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                          ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                                           ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                                          AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
                                  /*LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                                           ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                                          AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()*/
                                  -- LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalTo ON JuridicalTo.JuridicalId = MovementLinkObject_To.ObjectId
                                  -- LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalFrom ON JuridicalFrom.JuridicalId = MovementLinkObject_From.ObjectId
                                  LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS JuridicalTo
                                                                                      ON JuridicalTo.JuridicalId = MovementLinkObject_To.ObjectId
                                                                                     AND Movement.OperDate >= JuridicalTo.StartDate AND Movement.OperDate < JuridicalTo.EndDate
                                  LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS JuridicalFrom
                                                                                      ON JuridicalFrom.JuridicalId = MovementLinkObject_From.ObjectId
                                                                                     AND Movement.OperDate >= JuridicalFrom.StartDate AND Movement.OperDate < JuridicalFrom.EndDate
                             WHERE TRIM (JuridicalFrom.INN) = TRIM (inFromINN) AND TRIM (JuridicalTo.INN) = TRIM (inToINN)
                               AND ABS (inTotalSumm) = ABS (MovementFloat_TotalSumm.ValueData)
                               AND COALESCE (MovementString_InvNumberBranch.ValueData, '') = COALESCE (inInvNumberBranch, '')
--                             AND (inInvNumberRegistered = '' OR COALESCE(MovementString_InvNumberRegistered.ValueData, '') = '')
                             LIMIT 1
                            ) ;
        ELSE
             vbMovementId:= (WITH tmp AS (SELECT Movement.Id, Movement.OperDate
                                          FROM Movement
                                               LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                          WHERE MovementString_InvNumberPartner.ValueData = inInvNumber 
                                            AND Movement.OperDate = inOperDate AND Movement.DescId = zc_Movement_TaxCorrective()
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                                         )
                             SELECT Movement.Id
                             FROM tmp AS Movement
                                  LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                          ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                         AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                  LEFT JOIN MovementString AS MovementString_InvNumberBranch
                                                           ON MovementString_InvNumberBranch.MovementId =  Movement.Id
                                                          AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
                                  /*LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                                           ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                                          AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()*/
                                  -- LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalTo ON JuridicalTo.JuridicalId = MovementLinkObject_To.ObjectId
                                  -- LEFT JOIN ObjectHistory_JuridicalDetails_View AS JuridicalFrom ON JuridicalFrom.JuridicalId = MovementLinkObject_From.ObjectId

                                  LEFT JOIN MovementLinkMovement AS MovementLinkMovement_child
                                                                 ON MovementLinkMovement_child.MovementId = Movement.Id
                                                                AND MovementLinkMovement_child.DescId = zc_MovementLinkMovement_Child()
                                  LEFT JOIN Movement AS Movement_child ON Movement_child.Id = MovementLinkMovement_child.MovementChildId

                                  LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS JuridicalTo
                                                                                      ON JuridicalTo.JuridicalId = MovementLinkObject_To.ObjectId
                                                                                     AND COALESCE (Movement_child.OperDate, Movement.OperDate) >= JuridicalTo.StartDate AND COALESCE (Movement_child.OperDate, Movement.OperDate) < JuridicalTo.EndDate
                                  LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS JuridicalFrom
                                                                                      ON JuridicalFrom.JuridicalId = MovementLinkObject_From.ObjectId
                                                                                     AND COALESCE (Movement_child.OperDate, Movement.OperDate) >= JuridicalFrom.StartDate AND COALESCE (Movement_child.OperDate, Movement.OperDate) < JuridicalFrom.EndDate

                             WHERE TRIM (JuridicalFrom.INN) = TRIM (inToINN) AND TRIM (JuridicalTo.INN) = TRIM (inFromINN)
                               AND ABS (inTotalSumm) = ABS (MovementFloat_TotalSumm.ValueData)
                               AND COALESCE (MovementString_InvNumberBranch.ValueData, '') = COALESCE (inInvNumberBranch, '')
--                             AND (inInvNumberRegistered = '' OR COALESCE(MovementString_InvNumberRegistered.ValueData, '') = '')
                             LIMIT 1
                            ) ;
      END IF;

      -- Если нашли, то установили связь
      IF COALESCE (vbMovementId, 0) <> 0 THEN
        UPDATE Movement SET ParentId = vbMovementId WHERE Id = vbMedocId;
      END IF;

   END IF;

   -- Установили регистрацию
   IF (COALESCE(vbMovementId, 0)) <> 0 AND (COALESCE(inInvNumberRegistered, '') <> '')
   THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Electron(), vbMovementId, TRUE);
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberRegistered(), vbMovementId, inInvNumberRegistered);
      PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_DateRegistered(), vbMovementId, inDateRegistered);

      -- сохранили протокол
      PERFORM lpInsert_MovementProtocol (vbMovementId, zc_Enum_Process_Auto_Medoc() /*vbUserId*/, FALSE);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (vbMedocId, zc_Enum_Process_Auto_Medoc() /*vbUserId*/, FALSE);
   -- сохранили связь
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), vbMedocId, /*zc_Enum_Process_Auto_Medoc()*/ vbUserId);
   -- сохранили 
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), vbMedocId, CURRENT_TIMESTAMP);

   -- сохранили 
   PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentCustomer(), vbMedocId, inMedocCharCode);
  
   -- RAISE EXCEPTION 'Ошибка.<%>', vbMedocId;

   -- !!!не загружать строчную часть!!!
   outId := 0;   	
 

   -- insert into _tmp111 (Id)  select inMedocCode union select -1 * coalesce (vbMedocId, 0);
   -- select * from _tmp111
   -- delete from _tmp111
   /*
     IF TRIM (inInvNumberRegistered) = '9240071276'
     THEN
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
          SELECT 5, CURRENT_TIMESTAMP, 5
               , inMedocCode :: TVarChar
       || ';' || inFromINN
       || ';' || inToINN
       || ';' || inInvNumber
       || ';' || DATE (inOperDate) :: TVarChar
       || ';' || inInvNumberBranch
       || ';' || inInvNumberRegistered
       || ';' || DATE (inDateRegistered) :: TVarChar
       || ';' || inDocKind
       || ';' || inContract
       || ';' || inTotalSumm :: TVarChar
       || ';' || inSession
       , true;
     END IF;
*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 27.05.15                         * 
 19.05.15                         * 
 21.04.15                         * 
 02.04.15                         * 
 31.03.15                         * 

*/

-- тест
/*
 select * from gpUpdate_IsElectronFromMedoc (inMedocCode           := 536485
                                           , inFromINN             := '244471804626'
                                           , inToINN               := '100000000000'
                                           , inInvNumber           := '2067'
                                           , inOperDate            := '11.11.2015'
                                           , inInvNumberBranch     := ''
                                           , inInvNumberRegistered := '9238740621'
                                           , inDateRegistered      := '23.11.2015'
                                           , inDocKind             := 'Tax'
                                           , inContract            := '500006'
                                           , inTotalSumm           := 374.27
                                           , inSession             := '5'
                                            );
*/
