DROP FUNCTION IF EXISTS lpComplete_Movement_Payment (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Payment(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbPaymentDate TDateTime;
   DECLARE vbOperDate TDateTime;
BEGIN
    
    --Проверяем, что бы все оплаты соответствовали тем, что в документе
    PERFORM lpInsertUpdate_MovementItem_Payment_Child(inId     := MI_Payment.Id, -- Ключ объекта <Элемент документа>
                                                      inUserId := inUserId    -- сессия пользователя
                                                      )
    FROM MovementItem AS MI_Payment
    WHERE MI_Payment.MovementId = inMovementId
      AND MI_Payment.DescId = zc_MI_Master()
    ;

    
    SELECT Movement_Payment.OperDate             AS OperDate
         , MovementLinkObject_Juridical.ObjectId AS JuridicalId
        INTO vbOperDate, vbJuridicalId
    FROM Movement AS Movement_Payment
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                      ON MovementLinkObject_Juridical.MovementId = Movement_Payment.Id
                                     AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
    WHERE Movement_Payment.Id = inMovementId;

    -- создаются временные таблицы - для формирование данных для проводок
    PERFORM lpComplete_Movement_Finance_CreateTemp();
    
    --таблица строк док.
    CREATE TEMP TABLE _tmpMI(MovementId Integer, Id Integer, IncomeId Integer, Income_JuridicalId Integer, BankAccountId Integer, MovementBankAccountId Integer, SummaPay TFloat, SummaCorrOther TFloat, SummaCorrBonus TFloat, SummaCorrReturnOut TFloat, SummaCorrPartialSale  TFloat) ON COMMIT DROP;
    INSERT INTO _tmpMI (MovementId, Id, IncomeId, Income_JuridicalId, BankAccountId, MovementBankAccountId, SummaPay, SummaCorrOther, SummaCorrBonus, SummaCorrReturnOut, SummaCorrPartialSale)
        SELECT MI_Payment.MovementId
             , MI_Payment.Id
             , MIFloat_IncomeId.ValueData::Integer              AS IncomeId
             , MLO_From.ObjectId                                AS Income_JuridicalId
             , COALESCE (MILinkObject_BankAccount.ObjectId, 0)  AS BankAccountId
             , MIFloat_MovementBankAccount.ValueData  ::Integer AS MovementBankAccountId
             
             , MI_Payment.Amount                 AS SummaPay
             , MIFloat_CorrOther.ValueData       AS SummaCorrOther
             , MIFloat_CorrBonus.ValueData       AS SummaCorrBonus
             , MIFloat_CorrReturnOut.ValueData   AS SummaCorrReturnOut
             , MIFloat_CorrPartialSale.ValueData AS SummaCorrPartialSale
        FROM MovementItem AS MI_Payment
         INNER JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                        ON MIBoolean_NeedPay.MovementItemId = MI_Payment.Id
                                       AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
                                       AND MIBoolean_NeedPay.ValueData = TRUE

         LEFT JOIN MovementItemFloat AS MIFloat_CorrOther
                                     ON MIFloat_CorrOther.MovementItemId = MI_Payment.Id
                                    AND MIFloat_CorrOther.DescId = zc_MIFloat_CorrOther()
         LEFT JOIN MovementItemFloat AS MIFloat_CorrBonus
                                     ON MIFloat_CorrBonus.MovementItemId = MI_Payment.Id
                                    AND MIFloat_CorrBonus.DescId = zc_MIFloat_CorrBonus()
         LEFT JOIN MovementItemFloat AS MIFloat_CorrReturnOut
                                     ON MIFloat_CorrReturnOut.MovementItemId = MI_Payment.ID
                                    AND MIFloat_CorrReturnOut.DescId = zc_MIFloat_CorrReturnOut()
         LEFT JOIN MovementItemFloat AS MIFloat_CorrPartialSale
                                     ON MIFloat_CorrPartialSale.MovementItemId = MI_Payment.ID
                                    AND MIFloat_CorrPartialSale.DescId = zc_MIFloat_CorrPartialPay()

         LEFT JOIN MovementItemFloat AS MIFloat_IncomeId
                                     ON MIFloat_IncomeId.MovementItemId = MI_Payment.Id
                                    AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()
         
         LEFT JOIN MovementLinkObject AS MLO_From
                                      ON MLO_From.MovementId = MIFloat_IncomeId.ValueData::INTEGER
                                     AND MLO_From.DescId = zc_MovementLinkObject_From()

         LEFT JOIN MovementitemLinkObject AS MILinkObject_BankAccount
                                          ON MILinkObject_BankAccount.MovementItemId = MI_Payment.Id
                                         AND MILinkObject_BankAccount.DescId = zc_MILinkObject_BankAccount()

         LEFT OUTER JOIN MovementItem AS MI_MovementBankAccount
                                      ON MI_MovementBankAccount.ParentId = MI_Payment.Id
         LEFT OUTER JOIN MovementItemFloat AS MIFloat_MovementBankAccount
                                           ON MIFloat_MovementBankAccount.MovementItemId = MI_MovementBankAccount.Id
                                          AND MIFloat_MovementBankAccount.DescId = zc_MIFloat_MovementId()

        WHERE MI_Payment.MovementId = inMovementId
          AND MI_Payment.DescId = zc_MI_Master()
          AND MI_Payment.isErased = FALSE;
    
	ANALYSE _tmpMI;
    
    --Создать документы изменения долга по недостающим суммам прочих корректировок
    CREATE TEMP TABLE _tmp(OperDate TDateTime, JuridicalId Integer, Income_JuridicalId Integer, SummaCorrOther TFloat) ON COMMIT DROP;
    WITH 
    A AS
    (
        SELECT vbOperDate                            AS OperDate
             , vbJuridicalId                         AS JuridicalId
             
             , MI_Payment.Income_JuridicalId         AS Income_JuridicalId
             , SUM(MI_Payment.SummaCorrOther)        AS SummaCorrOther
        FROM _tmpMI AS MI_Payment
        WHERE MI_Payment.SummaCorrOther <> 0

        GROUP BY MI_Payment.Income_JuridicalId
        HAVING SUM(MI_Payment.SummaCorrOther) <> 0
    ),
    B AS
    (
        SELECT
            CLO_JuridicalBasis.ObjectId as JuridicalBasicId
           ,CLO_Juridical.ObjectId AS JuridicalId
           ,SUM(Container.Amount) as Amount
        FROM
            Container
            LEFT OUTER JOIN ContainerLinkObject AS CLO_Juridical
                                                ON CLO_Juridical.ContainerId = Container.Id
                                               AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
            LEFT OUTER JOIN ContainerLinkObject AS CLO_JuridicalBasis
                                                ON CLO_JuridicalBasis.ContainerId = Container.Id
                                               AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
        WHERE
            Container.DescId = zc_Container_SummIncomeMovementPayment() 
            AND 
            Container.ObjectId = zc_Enum_ChangeIncomePaymentKind_Other()
            AND
            Container.Amount <> 0
        GROUP BY
            CLO_JuridicalBasis.ObjectId
           ,CLO_Juridical.ObjectId
        HAVING
            SUM(Container.Amount) <> 0
    ),
    C AS
    (
        SELECT
            A.OperDate
           ,A.JuridicalId
           ,A.Income_JuridicalId
           ,(A.SummaCorrOther - COALESCE(B.Amount,0))::TFloat AS SummaCorrOther
        FROM
            A
            LEFT OUTER JOIN B ON A.JuridicalId = B.JuridicalBasicId
                             AND A.Income_JuridicalId = B.JuridicalId
        WHERE
            (
                A.SummaCorrOther > 0
                AND
                A.SummaCorrOther > COALESCE(B.Amount,0)
            )
            OR
            (
                A.SummaCorrOther < 0
                AND
                A.SummaCorrOther < COALESCE(B.Amount,0)
            )
            
    )
    Insert Into _Tmp Select * from C;
    PERFORM
        lpComplete_Movement_ChangeIncomePayment(inMovementId := lpInsertUpdate_Movement_ChangeIncomePayment(ioId                        :=0,
                                                                                                            inInvNumber                 :=NEXTVAL('movement_ChangeIncomePayment_seq')::TVarChar,
                                                                                                            inOperDate                  :=_Tmp.OperDate,
                                                                                                            inTotalSumm                 :=_Tmp.SummaCorrOther,
                                                                                                            inFromId                    :=_Tmp.Income_JuridicalId,
                                                                                                            inJuridicalId               :=_Tmp.JuridicalId,
                                                                                                            inChangeIncomePaymentKindId :=zc_Enum_ChangeIncomePaymentKind_Other(),
                                                                                                            inComment                   :=NULL::TVarChar,
                                                                                                            inUserId                    :=inUserId),
                                                inUserId := inUserId)
    FROM _Tmp;
    
	ANALYSE _tmp;
	
    -- проводим оплаты
    PERFORM
        lpComplete_Movement_BankAccount (inMovementId := MI_Payment.MovementBankAccountId
                                       , inUserId     := inUserId)
    FROM _tmpMI AS MI_Payment
    WHERE MI_Payment.SummaPay > 0
      AND MI_Payment.BankAccountId > 0;
    
    -- Создаем проводки переброски сумм с документов корректировки долга на приходы
    -- !!!обязательно!!! очистили таблицу проводок
    DELETE FROM _tmpMIContainer_insert;
    -- !!!обязательно!!! очистили таблицу - элементы документа, со всеми свойствами для формирования Аналитик в проводках
    DELETE FROM _tmpItem;
    
    -- Снимаем сумму с контейнера корректировок
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := zc_Enum_ChangeIncomePaymentKind_Bonus(), -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL, -- <элемент с/с> - необычная аналитика счета
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                               inObjectId_1        := MovementItem_Payment.Income_JuridicalId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId для 1-ой Аналитики
                               inObjectId_2        := vbJuridicalId) 
      , null
      , - MovementItem_Payment.SummaCorrBonus
      , vbOperDate

    FROM _tmpMI AS MovementItem_Payment
    WHERE MovementItem_Payment.SummaCorrBonus <> 0;
        
    -- Снимаем сумму с контейнера оплаты по накладной
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := lpInsertFind_Object_PartionMovement(MovementItem_Payment.IncomeId), -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL -- <элемент с/с> - необычная аналитика счета
                               ) 
      , null
      , -MovementItem_Payment.SummaCorrBonus
      , vbOperDate
    FROM _tmpMI AS MovementItem_Payment
    WHERE MovementItem_Payment.SummaCorrBonus <> 0;
        
    -- Снимаем сумму с контейнера корректировок
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := zc_Enum_ChangeIncomePaymentKind_ReturnOut(), -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL, -- <элемент с/с> - необычная аналитика счета
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                               inObjectId_1        := MovementItem_Payment.Income_JuridicalId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId для 1-ой Аналитики
                               inObjectId_2        := vbJuridicalId) 
      , null
      , -MovementItem_Payment.SummaCorrReturnOut
      , vbOperDate
    FROM _tmpMI AS MovementItem_Payment
    WHERE MovementItem_Payment.SummaCorrReturnOut <> 0;
        
    -- Снимаем сумму с контейнера оплаты по накладной
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := lpInsertFind_Object_PartionMovement(MovementItem_Payment.IncomeId), -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL -- <элемент с/с> - необычная аналитика счета
                               ) 
      , null
      , -MovementItem_Payment.SummaCorrReturnOut
      , vbOperDate
    FROM _tmpMI AS MovementItem_Payment
    WHERE MovementItem_Payment.SummaCorrReturnOut <> 0;    
        
    -- Снимаем сумму с контейнера корректировок
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := zc_Enum_ChangeIncomePaymentKind_Other(), -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL, -- <элемент с/с> - необычная аналитика счета
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                               inObjectId_1        := MovementItem_Payment.Income_JuridicalId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId для 1-ой Аналитики
                               inObjectId_2        := vbJuridicalId) 
      , null
      , -MovementItem_Payment.SummaCorrOther
      , vbOperDate
     FROM _tmpMI AS MovementItem_Payment
     WHERE MovementItem_Payment.SummaCorrOther <> 0;
        
    -- Снимаем сумму с контейнера корректировок
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := zc_Enum_ChangeIncomePaymentKind_PartialSale(), -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL, -- <элемент с/с> - необычная аналитика счета
                               inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId для 1-ой Аналитики
                               inObjectId_1        := MovementItem_Payment.Income_JuridicalId,
                               inDescId_2          := zc_ContainerLinkObject_JuridicalBasis(), -- DescId для 1-ой Аналитики
                               inObjectId_2        := vbJuridicalId) 
      , null
      , - MovementItem_Payment.SummaCorrPartialSale
      , vbOperDate
     FROM _tmpMI AS MovementItem_Payment
     WHERE MovementItem_Payment.SummaCorrPartialSale <> 0;
        
    -- Снимаем сумму с контейнера оплаты по накладной
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Payment()  
      , inMovementId
      , lpInsertFind_Container(inContainerDescId   := zc_Container_SummIncomeMovementPayment(), -- DescId Остатка
                               inParentId          := NULL               , -- Главный Container
                               inObjectId          := lpInsertFind_Object_PartionMovement(MovementItem_Payment.IncomeId), -- Объект (Счет или Товар или ...)
                               inJuridicalId_basis := vbJuridicalId, -- Главное юридическое лицо
                               inBusinessId        := NULL, -- Бизнесы
                               inObjectCostDescId  := NULL, -- DescId для <элемент с/с>
                               inObjectCostId      := NULL -- <элемент с/с> - необычная аналитика счета
                               ) 
      , null
      , -MovementItem_Payment.SummaCorrOther
      , vbOperDate
    FROM _tmpMI AS MovementItem_Payment
    WHERE MovementItem_Payment.SummaCorrOther <> 0;
    

    PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Payment()
                               , inUserId     := inUserId
                                 );
                                 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 08.01.18         * без вьюх
 13.10.15                                                                     * 
*/