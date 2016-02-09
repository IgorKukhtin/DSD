-- select * from gpGet_Scale_Movement(inMovementId := 1506795 , inOperDate := ('15.05.2015')::TDateTime , inIsNext := 'True' ,  inSession := '5');

select lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_StartPosInt(), tmp.Id, tmp.StartPosInt)
     , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_EndPosInt(), tmp.Id, tmp.EndPosInt)
     
     , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_StartPosFrac(), tmp.Id, tmp.StartPosFrac)
     , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_EndPosFrac(), tmp.Id, tmp.EndPosFrac)

     , tmp.*
from
(select Object.*
      , case when Object.Id = 83954 -- 16;3;"Метро";f;;0;0
                  then 7
             when Object.Id in (83959 -- ;16;8;"Билла";f;;0;0
                              , 84098) -- ;16;9;"Билла-2";f;;0;0
                  then 8
             when Object.Id = 83963 -- ;16;13;"Ашан";f;;0;0
                  then 9
             when Object.Id = 83953 -- ;16;2;"Киев ОК";f;;0;0
                  then 9
             when Object.Id = 83956 -- ;16;5;"Фоззи";f;;0;0
                  then 8
             when Object.Id in (83957 -- ;16;6;"Кишени";f;;0;0
                              , 420377) -- ;16;81;"Кишени-Кулинария";f;;0;0
                  then 9
             when Object.Id = 83958 -- ;16;7;"Виват";f;;0;0
                  then 9
             when Object.Id = 83960 -- ;16;10;"Амстор";f;;0;0
                  then 9
             when Object.Id = 83964 -- ;16;14;"Реал";f;;0;0
                  then 7
             when Object.Id = 83952 -- ;16;1;"АТБ";f;;0;0
                  then 7
             when Object.Id = 83955 -- ;16;4;"Алан";f;;0;0
                  then 8
             else 0
        end as StartPosInt

      , case when Object.Id = 83954 -- 16;3;"Метро";f;;0;0
                  then 9
             when Object.Id in (83959 -- ;16;8;"Билла";f;;0;0
                              , 84098) -- ;16;9;"Билла-2";f;;0;0
                  then 9
             when Object.Id = 83963 -- ;16;13;"Ашан";f;;0;0
                  then 9
             when Object.Id = 83953 -- ;16;2;"Киев ОК";f;;0;0
                  then 9
             when Object.Id = 83956 -- ;16;5;"Фоззи";f;;0;0
                  then 9
             when Object.Id in (83957 -- ;16;6;"Кишени";f;;0;0
                              , 420377) -- ;16;81;"Кишени-Кулинария";f;;0;0
                  then 9
             when Object.Id = 83958 -- ;16;7;"Виват";f;;0;0
                  then 9
             when Object.Id = 83960 -- ;16;10;"Амстор";f;;0;0
                  then 9
             when Object.Id = 83964 -- ;16;14;"Реал";f;;0;0
                  then 9
             when Object.Id = 83952 -- ;16;1;"АТБ";f;;0;0
                  then 8
             when Object.Id = 83955 -- ;16;4;"Алан";f;;0;0
                  then 9
             else 0
        end as EndPosInt

      , case when Object.Id = 83954 -- 16;3;"Метро";f;;0;0
                  then 10
             when Object.Id in (83959 -- ;16;8;"Билла";f;;0;0
                              , 84098) -- ;16;9;"Билла-2";f;;0;0
                  then 10
             when Object.Id = 83963 -- ;16;13;"Ашан";f;;0;0
                  then 10
             when Object.Id = 83953 -- ;16;2;"Киев ОК";f;;0;0
                  then 10
             when Object.Id = 83956 -- ;16;5;"Фоззи";f;;0;0
                  then 10
             when Object.Id in (83957 -- ;16;6;"Кишени";f;;0;0
                              , 420377) -- ;16;81;"Кишени-Кулинария";f;;0;0
                  then 10
             when Object.Id = 83958 -- ;16;7;"Виват";f;;0;0
                  then 10
             when Object.Id = 83960 -- ;16;10;"Амстор";f;;0;0
                  then 10
             when Object.Id = 83964 -- ;16;14;"Реал";f;;0;0
                  then 10
             when Object.Id = 83952 -- ;16;1;"АТБ";f;;0;0
                  then 9
             when Object.Id = 83955 -- ;16;4;"Алан";f;;0;0
                  then 10
             else 0
        end as StartPosFrac

       , case when Object.Id = 83954 -- 16;3;"Метро";f;;0;0
                  then 12
             when Object.Id in (83959 -- ;16;8;"Билла";f;;0;0
                              , 84098) -- ;16;9;"Билла-2";f;;0;0
                  then 12
             when Object.Id = 83963 -- ;16;13;"Ашан";f;;0;0
                  then 12
             when Object.Id = 83953 -- ;16;2;"Киев ОК";f;;0;0
                  then 12
             when Object.Id = 83956 -- ;16;5;"Фоззи";f;;0;0
                  then 12
             when Object.Id in (83957 -- ;16;6;"Кишени";f;;0;0
                              , 420377) -- ;16;81;"Кишени-Кулинария";f;;0;0
                  then 12
             when Object.Id = 83958 -- ;16;7;"Виват";f;;0;0
                  then 12
             when Object.Id = 83960 -- ;16;10;"Амстор";f;;0;0
                  then 12
             when Object.Id = 83964 -- ;16;14;"Реал";f;;0;0
                  then 12
             when Object.Id = 83952 -- ;16;1;"АТБ";f;;0;0
                  then 11
             when Object.Id = 83955 -- ;16;4;"Алан";f;;0;0
                  then 12
             else 0
        end as EndPosFrac
 from Object
 WHERE Object.DescId = zc_Object_GoodsProperty()
    and Object.Id in (83954 -- 16;3;"Метро";f;;0;0
                    , 83959 -- ;16;8;"Билла";f;;0;0
                    , 84098 -- ;16;9;"Билла-2";f;;0;0
                    , 83963 -- ;16;13;"Ашан";f;;0;0
                    , 83953 -- ;16;2;"Киев ОК";f;;0;0
                    , 83956 -- ;16;5;"Фоззи";f;;0;0
                    , 83957 -- ;16;6;"Кишени";f;;0;0
                    , 420377 -- ;16;81;"Кишени-Кулинария";f;;0;0
                    , 83958 -- ;16;7;"Виват";f;;0;0
                    , 83960 -- ;16;10;"Амстор";f;;0;0
                    , 83964 -- ;16;14;"Реал";f;;0;0
                    , 83952 -- ;16;1;"АТБ";f;;0;0
                    , 83955 -- ;16;4;"Алан";f;;0;0
                     )
 order by 3
) as tmp


