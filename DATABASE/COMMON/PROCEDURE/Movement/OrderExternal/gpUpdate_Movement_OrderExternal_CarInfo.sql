-- Function: gpUpdate_Movement_OrderExternal_CarInfo()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TFloat,  TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_CarInfo (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_CarInfo(
    IN inOperDate                TDateTime , -- Дата документа
    IN inOperDatePartner         TDateTime , -- Дата отгрузки со склада
    --IN inOperDate_CarInfo        TDateTime , --
    IN inToId                    Integer   , -- Кому (в документе)
    IN inRouteId                 Integer   , -- Маршрут
    IN inRetailId                Integer   , -- торг. сеть
    IN inDays                    Integer   , --  +/- кол-во дней
    IN inTimes                   TFloat    , --  время
    IN inCarInfoName             TVarChar  , --  информация
    IN inCarComment              TVarChar  , -- примечание к отгрузке 
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCarInfoId Integer;
   DECLARE vbOperDate_CarInfo TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal()); 
     
     vbOperDate_CarInfo := ((inOperDatePartner + ( inDays||' Day') ::interval)::Date
                           ||' '||REPLACE (CAST (inTimes AS NUMERIC (16,2)) ::TVarChar,'.' ,':') ) TDateTime; 
     
      --RAISE EXCEPTION '<%>', vbOperDate_CarInfo;
      
     -- пробуем найти  CarInfoId
     vbCarInfoId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CarInfo() AND Object.ValueData = TRIM (inCarInfoName) AND Object.isErased = False);
     IF COALESCE (vbCarInfoId,0) = 0
     THEN
         --сохраняем
         vbCarInfoId := gpInsertUpdate_Object_CarInfo ( ioId       := 0     Integer   ,     -- ключ объекта <Регионы> 
                                                      , inCode     := 0     Integer   ,     -- Код объекта  
                                                      , inName     := TRIM (inCarInfoName) ::TVarChar  ,     -- Название объекта 
                                                      , inSession  := inSession            ::TVarChar        -- сессия пользователя
                                                      );
     END IF;
                                                      
     ---
     PERFORM --lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), tmp.Id, inOperDate_CarInfo)        -- Дата/время отгрузки
             lpInsertUpdate_MovementDate (zc_MovementDate_CarInfo(), tmp.Id, vbOperDate_CarInfo)        -- Дата/время отгрузки
           , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CarInfo(), tmp.Id, vbCarInfoId)   -- Информация по отгрузке 
           , lpInsertUpdate_MovementString (zc_MovementString_CarComment(), ioId, inCarComment)         -- примечание к отгрузке
     FROM (SELECT Movement.Id
           FROM Movement
               INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                      AND MovementDate_OperDatePartner.ValueData = inOperDatePartner
 
               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                            AND COALESCE (MovementLinkObject_To.ObjectId,0) = inToId
 
               LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                            ON MovementLinkObject_Route.MovementId = Movement.Id
                                           AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
 
               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
 
               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                           
           WHERE Movement.OperDate = inOperDate
             AND Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.DescId = zc_Movement_OrderExternal()
             AND inRetailId = COALESCE (CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE ObjectLink_Juridical_Retail.ChildObjectId END, 0)
             AND COALESCE (MovementLinkObject_Route.ObjectId, 0) = inRouteId
             ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.06.22         *
 16.06.22         *
*/

-- тест
-- 