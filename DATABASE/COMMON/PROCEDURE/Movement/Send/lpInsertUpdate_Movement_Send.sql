-- Function: lpInsertUpdate_Movement_Send()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Send (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Send(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inDocumentKindId      Integer   , -- Тип документа (в документе)
    IN inSubjectDocId        Integer   , -- Основание для перемещения
    IN inComment             TVarChar  , -- Примечание
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate_old TDateTime;
BEGIN
     -- проверка
     IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
     THEN
         RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
     END IF;

     -- определяем ключ доступа
     vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_Send());

     -- проверка RK + Склад Неликвид
     IF inFromId IN (zc_Unit_RK(), 9558031) AND COALESCE (inSubjectDocId, 0) = 0
     AND inToId IN (8458, 8451 )
     THEN
         RAISE EXCEPTION 'Ошибка.%Нет прав формировать документ <Перемещение>.%Не заполнено <Основание для перемещения>.', CHR (13), CHR (13);
     END IF;

     -- определяем
     vbOperDate_old:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = ioId);

     -- проставляем партию для РК
     IF ioId > 0 AND inToId = zc_Unit_RK()
    AND inOperDate <> vbOperDate_old
    AND EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemLinkObject AS MILinkObject_PartionCell
                                                       ON MILinkObject_PartionCell.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_PartionCell.DescId IN (zc_MILinkObject_PartionCell_1()
                                                                                            , zc_MILinkObject_PartionCell_2()
                                                                                            , zc_MILinkObject_PartionCell_3()
                                                                                            , zc_MILinkObject_PartionCell_4()
                                                                                            , zc_MILinkObject_PartionCell_5()
                                                                                            , zc_MILinkObject_PartionCell_6()
                                                                                            , zc_MILinkObject_PartionCell_7()
                                                                                            , zc_MILinkObject_PartionCell_8()
                                                                                            , zc_MILinkObject_PartionCell_9()
                                                                                            , zc_MILinkObject_PartionCell_10()
                                                                                            , zc_MILinkObject_PartionCell_11()
                                                                                            , zc_MILinkObject_PartionCell_12()
                                                                                            , zc_MILinkObject_PartionCell_13()
                                                                                            , zc_MILinkObject_PartionCell_14()
                                                                                            , zc_MILinkObject_PartionCell_15()
                                                                                            , zc_MILinkObject_PartionCell_16()
                                                                                            , zc_MILinkObject_PartionCell_17()
                                                                                            , zc_MILinkObject_PartionCell_18()
                                                                                            , zc_MILinkObject_PartionCell_19()
                                                                                            , zc_MILinkObject_PartionCell_20()
                                                                                            , zc_MILinkObject_PartionCell_21()
                                                                                            , zc_MILinkObject_PartionCell_22()
                                                                                             )

                WHERE MovementItem.MovementId = ioId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.isErased   = FALSE
               )
    THEN
        PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), MovementItem.Id, vbOperDate_old)
        FROM MovementItem
             LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                        ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                       AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
        WHERE MovementItem.MovementId = ioId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased = FALSE
          AND MIDate_PartionGoods.ValueData IS NULL
         ;

    END IF;



     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Send(), inInvNumber, inOperDate, NULL, vbAccessKeyId, inUserId);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);

     -- сохранили связь с <Тип документа (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentKind(), ioId, inDocumentKindId);

     -- сохранили связь с <Основание для перемещения>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);

     -- Комментарий
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.02.20         * add inSubjectDocId
 27.02.19         *
 03.10.17         *
 17.06.16         *
 29.05.15                                        *
 12.07.13         *
*/

-- тест
-- SELECT min (OperDate), max (OperDate) FROM Movement where Desc = zc_Movement_Send() and AccessKeyId is null
-- SELECT * FROM lpInsertUpdate_Movement_Send (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inDocumentKindId:= 0, inComment:= '', inSession:= '2')
