# ML---Apriori-Association-Rule-Mining---MATLAB
Before everything I do pre-processing in the excel file itself (it is possible to do it in code but in excel file is much easier). I change
the file as following:
Apple = ‘i1’ and chocolate = ‘i16’ Because working with them is easier (compare files apriori_train.csv and apriori_train_pre_prossesed.csv)

**You need too save final_source.m file and apriori_train_pre_prossesed.csv file in same directory then "INSERT THE PATH OF YOUR DIRECTORY " in line 12 of the code after runnning the code you can fine priori_result.csv file in directory**
```diff
- running this code take time. you can remove some items and some transactions as well to reduce the time (remmeber to change item_number = 16  too)
```

## Code explanation:
just import the last column to the MATLAB as the following code line from 1 to 14.
I set the supp_troshold as 0.03*1000 =30 as far as we have 1000 data and the item_number = 16 as far as we have 16 items.

### main code:
- Main code start from line 16 by setting the number of items = 16 and set the minimum number for support number = 30.
- Then in line 19 call the function <b>finding_supp_count</b> to find the total number of support for each level and delete the rows that
- the support number is less than 30. You see that there is 5 level for total support number (means 5 items together).


![1](https://user-images.githubusercontent.com/92718738/204970712-0cfe9f1d-ade9-4605-b38d-7f676d805e4e.png)


- In the 5th level there is 119 transaction consist 5 items. then check all the relation in the 5th level of total support and if the confident >0.7 then save the relation and confident value in a table
- Next change the ‘i1’ to ‘i16’ to the real name of the item then save them as format that asked in exam and saved in the file.
### Functions: 
![image](https://user-images.githubusercontent.com/92718738/204971863-7e8c2442-0f96-49c0-9702-3b1691baabdc.png)

1- **finding_supp_count function:** 
this function get (**item** ,**number_of_items** ,**minimum_supp_troshold**) and as a result give the **total_supp** and **all_item**. 

![image](https://user-images.githubusercontent.com/92718738/204972271-f7d6132c-e358-47a7-a5f9-dfc42183409f.png)

it is 1by5 cell in each column there is number of support for items. For example in the last one that we are interesting on that
there is 119 item set and the number of support for them as the following, And in each cell in first column there is a strain of
items as follow: 

![image](https://user-images.githubusercontent.com/92718738/204972369-49927802-d4f2-4d90-acf9-7ff25c905db0.png)


**2- suppnumber_for_confidence function:**
This function is to give the **supp_count** and **total_supp** and it will give you all relations as the relation with is all possible relation for any confidence which later it will filtered by the minimum value for confidence


**3- confidence_table function:**
It calculate all the relations as the **total_relation** according to supp array and the support number that given to this function // use this for different support array in the last step ( total_supp{1,5} ) to find the all relation


**4- comper_items function:**
This function used to compare arrays you can  compare array  {**i1**,**i2**} with the {**i1**,**i2**,i3} also you can compare {**i1**,i2,**i3**} with the {**i1**,**i3**} because there is a strain {i2} between them. 


**5- comper_items_2_by_2 function:**
it is same as comer_items but here two item have same length 


**6- erase_repeted_cells function:**
This function used to arase the cells that are same after producing items in different K level


**7- erase_repitation function:**
It used to delete the repeated items when I produce the Kth level items

