 update HistoryCost set Price = calc.Price
from (
WITH tmp_settings AS (SELECT gpSelect.Price   , gpSelect.ContainerId , gpSelect.StartDate
                                                FROM dblink('host=192.168.0.213 dbname=project_a port=5432 user=admin password=vas6ok' :: Text
                                                          , (' SELECT HistoryCost.Price, HistoryCost.ContainerId, HistoryCost.StartDate'
                                    || ' FROM Container AS Container_Summ'
                                    || '      inner JOIN Container ON Container.Id = Container_Summ.ParentId'
                                    || '                and Container.ObjectId = 6883420 '

                                    || '      inner JOIN HistoryCost ON HistoryCost.ContainerId  = Container_Summ.Id'
                                    || '                and HistoryCost.StartDate < ''01.08.2023'''

                                    || ' WHERE Container_Summ.DescId = zc_Container_Summ()') :: Text
                                                           ) AS gpSelect (Price     TFloat, ContainerId Integer, StartDate TDateTime
                                                                         )
                                               )
select HistoryCost.Price as price_err, tmp_settings.*
from HistoryCost
 join tmp_settings on  tmp_settings.ContainerId  = HistoryCost.ContainerId
                   and tmp_settings.StartDate= HistoryCost.StartDate
                   and tmp_settings.Price <> HistoryCost.Price
order by 4, 3
) as calc
where calc.ContainerId = HistoryCost.ContainerId
  and calc.StartDate = HistoryCost.StartDate
  and 1=0
