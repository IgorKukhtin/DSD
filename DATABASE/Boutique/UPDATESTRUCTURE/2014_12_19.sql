DO $$ 
    BEGIN
        -- !!!MovementItemContainer!!!
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name = lower('MovementItemContainer') AND Column_Name = lower('ObjectId_Analyzer'))) THEN
            ALTER TABLE MovementItemContainer ADD COLUMN AccountId Integer;
            ALTER TABLE MovementItemContainer ADD COLUMN ObjectId_Analyzer Integer;
            ALTER TABLE MovementItemContainer ADD COLUMN WhereObjectId_Analyzer Integer;
            ALTER TABLE MovementItemContainer ADD COLUMN ContainerId_Analyzer Integer;

            /*
            UPDATE MovementItemContainer SET AccountId = case when Container.DescId = zc_Container_Summ() then Container.ObjectId else null end
                                           , ObjectId_Analyzer = MovementItem.ObjectId
                                           , WhereObjectId_Analyzer = MovementLinkObject.ObjectId
                                           , ContainerId_Analyzer = tmp.ContainerId_Analyzer
            FROM MovementItem, MovementLinkObject, Container
                ,(select MovementItemContainer.MovementId , min (MovementItemContainer.ContainerId) as ContainerId_Analyzer
                  FROM MovementItemContainer
                       INNER JOIN Container on Container.Id = ContainerId and Container.ObjectId <> zc_Enum_Account_110101()
                       INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                      ON ContainerLO_Juridical.ContainerId = MovementItemContainer.ContainerId
                                                     AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                  where MovementItemContainer.MovementDescId in (zc_Movement_Sale(), zc_Movement_ReturnIn())
                    AND MovementItemContainer.DescId = zc_MIContainer_Summ()
                    AND MovementItemContainer.OperDate >= '01.06.2014'
                  group by MovementItemContainer.MovementId
                 ) as tmp

            WHERE MovementItemContainer.MovementDescId in (zc_Movement_Sale(), zc_Movement_ReturnIn())
              AND MovementItemContainer.OperDate >= '01.06.2014'
              AND MovementItemContainer.AnalyzerId <> 0
              AND MovementItemContainer.MovementItemId = MovementItem.Id

              AND MovementLinkObject.MovementId = MovementItemContainer.MovementId
              AND MovementLinkObject.DescId = case when MovementItemContainer.MovementDescId = zc_Movement_Sale() then zc_MovementLinkObject_From() else zc_MovementLinkObject_To() end 
              AND Container.Id = MovementItemContainer.ContainerId
              AND Container.ObjectId <> zc_Enum_Account_100301 () -- прибыль текущего периода
              AND tmp.MovementId = MovementItemContainer.MovementId
           ;*/

        END IF;
    END;
$$;
