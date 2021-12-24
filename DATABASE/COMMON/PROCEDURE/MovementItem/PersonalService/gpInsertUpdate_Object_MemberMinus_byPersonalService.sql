-- Function: InsertUpdate_Object_MemberMinus_byPersonalService()

DROP FUNCTION IF EXISTS InsertUpdate_Object_MemberMinus_byPersonalService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION InsertUpdate_Object_MemberMinus_byPersonalService(
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE vbNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MemberMinus());

     CREATE TEMP TABLE tmpMemberMinus ON COMMIT DROP AS 
     WITH
          tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.PositionId
                               , lfSelect.isMain
                               , lfSelect.UnitId
                          FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                          WHERE lfSelect.Ord = 1
                         )
         -- Выбираем данные из справочника MemberMinus
        SELECT tmp.Id
             , tmp.FromId  AS MemberId
             , tmpPersonal.PersonalId
             , tmpPersonal.PositionId
             , CASE WHEN COALESCE (tmp.Tax,0) = 0 THEN 100 ELSE tmp.Tax END AS Tax
             , tmp.Number
             , tmp.isChild
             , SUM (tmp.Summ) AS Summ
        FROM gpSelect_Object_MemberMinus (FALSE, FALSE, inSession) AS tmp
             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmp.FromId
        WHERE tmp.isErased = FALSE
        GROUP BY tmp.FromId
             , tmpPersonal.PersonalId
             , tmpPersonal.PositionId
             , tmp.Tax, tmp.Number, tmp.isChild
        ;


     CREATE TEMP TABLE tmpData ON COMMIT DROP AS
        WITH
          --Данные из док. по оплатам алиментов и пр.удержаний
          tmpMI_All AS (SELECT tmp.*
                        FROM gpSelect_MovementItem_PersonalService(21646761 , FALSE, FALSE, inSession) AS tmp
                        WHERE COALESCE (tmp.SummChildRecalc,0) <> 0
                           OR COALESCE (tmp.SummMinusExtRecalc,0) <> 0
                       )

            --распределяем оплаты документа по % по исполнительным листам
            SELECT tmpMemberMinus.MemberId
                 , tmpMI_All.Number
                 , tmpMemberMinus.Tax
                 , CASE WHEN COALESCE (tmpMI_All.SummChildRecalc,0) <> 0 THEN TRUE ELSE FALSE END isChild 
                 , SUM (CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END) AS TotalSummMinus
                 , SUM ((CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END) * COALESCE (tmpMemberMinus.Tax,100) / 100) AS SummMinus
            FROM tmpMI_All
                 LEFT JOIN tmpMemberMinus ON tmpMemberMinus.PersonalId = tmpMI_All.PersonalId
                                         AND tmpMemberMinus.Number = tmpMI_All.Number
            GROUP BY tmpMemberMinus.MemberId
                   , tmpMI_All.Number
                   , tmpMemberMinus.Tax
                   , tmpMemberMinus.isChild 
            HAVING SUM (CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END) <> 0
         ;

     --проверка если распределено не 100 % / не вся сумма
     SELECT tmp.MemberId, tmp.Number
        INTO vbMemberId, vbNumber
     FROM (SELECT tmpData.Number
                , tmpData.MemberId
                , tmpCalc.TotalSummMinus
                , SUM (tmpCalc.Tax)       AS Tax
                , SUM (tmpCalc.SummMinus) AS SummMinus
           FROM tmpData
           GROUP BY tmpCalc.MemberId
                  , tmpCalc.TotalSummMinus
                  , tmpData.Number
           HAVING SUM (tmpCalc.Tax) <> 100
               OR SUM (tmpCalc.SummMinus) <> tmpCalc.TotalSummMinus
           LIMIT 1
           ) AS tmp;

     IF COALESCE (vbMemberId,0) <> 0
     THEN
          RAISE EXCEPTION 'Ошибка.По сотруднику <%> исп.лист № <%> распределено не 100%', lfGet_Object_ValueData (vbMemberId), vbNumber;
     END IF;
     
     
     -- сохраняем в справочнике
     PERFORM  lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Summ(), tmpMemberMinus.Id, tmpData.SummMinus)
     FROM tmpData
          INNER JOIN tmpMemberMinus ON tmpMemberMinus.MemberId = tmpData.MemberId
                                   AND tmpMemberMinus.Number = tmpData.Number
     WHERE COALESCE (tmpData.SummMinus,0) <> 0
     ;
     
     --добавляем єлемент справочника если такого исполнительногго  листа нет
     PERFORM gpInsertUpdate_Object_MemberMinus(ioId                   := 0   ::Integer       -- ключ объекта < >
                                             , inName                 := '' ::TVarChar      -- Примечание 
                                             , inBankAccountTo        := '' ::TVarChar      -- № счета получателя платежа
                                             , inDetailPayment        := '' ::TVarChar      -- Назначение платежа
                                             , inINN_to               := '' ::TVarChar      -- ОКПО/ИНН получателя
                                             , inToShort              := '' ::TVarChar      -- Юр. лицо (сокращенное значение) 
                                             , inNumber               := tmpData.Number   ::TVarChar      -- 
                                             , inFromId               := tmpData.MemberId ::Integer       -- Физические лица
                                             , inToId                 := NULL ::Integer       -- Физические лица(сторонние) / Юридические лица
                                             , ioBankAccountFromId    := NULL  ::Integer       -- IBAN плательщика платежа
                                             , inBankAccountToId      := NULL  ::Integer       -- IBAN получателя платежа
                                             , inBankAccountId_main   := NULL  ::Integer       --№ исполнительного листа
                                             , inTotalSumm            := tmpData.SummMinus::TFloat         -- Сумма Итого
                                             , inSumm                 := tmpData.SummMinus::TFloat         -- Сумма к удержанию ежемесячно
                                             , inTax                  := 100             ::TFloat         -- % удержания
                                             , inisChild              := tmpData.isChild ::Boolean        -- Алименты (да/нет)
                                             , inSession              := inSession       ::TVarChar        -- сессия пользователя
                                             )
     FROM tmpData
          LEFT JOIN tmpMemberMinus ON tmpMemberMinus.MemberId = tmpData.MemberId
                                   AND tmpMemberMinus.Number = tmpData.Number
     WHERE COALESCE (tmpData.SummMinus,0) <> 0 
       AND tmpMemberMinus.MemberId IS NULL
       AND COALESCE (tmpData.Number,'') <> ''
     ;

    IF (vbUserId = '5') OR (vbUserId = '9457')
    THEN
        RAISE EXCEPTION 'Запретили Админу :)';
    END IF;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.21         *
*/

-- тест
-- select * from gpInsertUpdate_MI_PersonalService_byMemberMinus(inMovementId := 18002434 ,  inSession := '5');

/*

    WITH
          tmpPersonal AS (SELECT lfSelect.MemberId
                               , lfSelect.PersonalId
                               , lfSelect.PositionId
                               , lfSelect.isMain
                               , lfSelect.UnitId
                          FROM lfSelect_Object_Member_findPersonal ('5') AS lfSelect
                          WHERE lfSelect.Ord = 1
                         )
      , tmpMemberMinus AS ( SELECT tmp.FromId  AS MemberId
             , tmpPersonal.PersonalId
             , tmpPersonal.PositionId
             , CASE WHEN COALESCE (tmp.Tax,0) = 0 THEN 80 ELSE tmp.Tax END AS Tax
, tmp.Number
, tmp.isChild
             , SUM (tmp.Summ) AS Summ
             
        FROM gpSelect_Object_MemberMinus (FALSE, FALSE, '5') AS tmp
             LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = tmp.FromId
        WHERE tmp.isErased = FALSE
        GROUP BY tmp.FromId
             , tmpPersonal.PersonalId
             , tmpPersonal.PositionId
             , tmp.Tax, tmp.Number, tmp.isChild
              )

           , tmpMI_All AS (SELECT tmp.*
                          FROM gpSelect_MovementItem_PersonalService(21646761 , FALSE, FALSE, '5') AS tmp
                          WHERE COALESCE (tmp.SummChildRecalc,0) <> 0
                             OR COALESCE (tmp.SummMinusExtRecalc,0) <> 0
                         )

           , tmpCalc AS (SELECT tmpMemberMinus.MemberId
                 , tmpMI_All.PersonalId
                 , CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END AS TotalSummMinus
                 , tmpMemberMinus.Tax
                 , tmpMemberMinus.isChild 
                 , ((CASE WHEN COALESCE (tmpMemberMinus.isChild,TRUE) = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END) * COALESCE (tmpMemberMinus.Tax,100) / 100) AS SummMinus
 
            FROM tmpMI_All
                 LEFT JOIN tmpMemberMinus ON tmpMemberMinus.PersonalId = tmpMI_All.PersonalId
                                        -- AND tmpMemberMinus.Number = tmpMI_All.Number
            WHERE CASE WHEN tmpMemberMinus.isChild = TRUE THEN COALESCE (tmpMI_All.SummChildRecalc,0) ELSE COALESCE (tmpMI_All.SummMinusExtRecalc,0) END <> 0
           )

SELECT tmpCalc.MemberId
, tmpCalc.TotalSummMinus
 , SUM (tmpCalc.Tax) AS Tax
, SUM (tmpCalc.SummMinus) AS SummMinus
FROM tmpCalc
GROUP BY tmpCalc.MemberId
       , tmpCalc.TotalSummMinus
HAVING SUM (tmpCalc.Tax) <> 100
OR SUM (tmpCalc.SummMinus) <> tmpCalc.TotalSummMinus

           */
