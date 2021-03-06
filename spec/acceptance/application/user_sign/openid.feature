Feature: Open ID 註冊 / 登入
  Background:
    Given 已註冊 users:
          | name  | email           |
          | marsz | marsz@5fpro.com |
  Scenario: Email 為空
     When facebook 登入
          | email |  |
     Then 使用者未登入
  Scenario: 已登入下，重複綁定相同的 Open ID 不會造成資料錯誤，且會更新已存的 Open ID 資料
    Given 使用者登入
      And facebook 登入
          | email | marsz@5fpro.com |
          | uid   | 12345           |
          | name  | marsz           |
     When facebook 登入
          | email | marsz@5fpro.com |
          | uid   | 12345           |
          | name  | mars            |
     Then User(marsz) 已綁定 facebook 1 筆
      And User(marsz) 的 facebook 資料為:
          | uid   | 12345 |
          | name  | mars  |
  Scenario: 已登入下，同一個 Open ID 來源可重複綁定不同的帳號
    Given 使用者登入
      And facebook 登入
          | email | marsz@5fpro.com |
          | uid   | 12345           |
     When facebook 登入
          | email | abcd@5fpro.com |
          | uid   | 56789          |
     Then User(marsz) 已綁定 facebook 2 筆
  Scenario: 已登入下，若原為一般註冊，綁定後仍可以原帳號密碼登入
    Given 使用者登入
      And facebook 登入
          | email | marsz@5fpro.com |
      And 使用者登出
     When 使用者登入
     Then 使用者已登入
  Scenario: 已登入下，該 Open ID 已綁定在其他 user 身上時，無法進行綁定
    Given 已註冊 users:
          | name  | email           |
          | venus | venus@5fpro.com |
      And User(venus) 綁定 facebook
          | uid   | 1234            |
      And 使用者登入
     When facebook 登入
          | uid   | 1234            |
     Then User(marsz) 已綁定 facebook 0 筆
  Scenario: 已登入下，相同 Email 的不同 Open ID 已綁定(註冊)在其他 user 身上時，則無法進行綁定。
    Given 已註冊 users:
          | name  | email           |
          | venus | venus@5fpro.com |
      And User(venus) 綁定 facebook
          | uid   | 1234            |
          | email | xxx@5fpro.com   |
      And 使用者登入
     When google 登入
          | uid   | 5678            |
          | email | xxx@5fpro.com   |
     Then User(marsz) 已綁定 facebook 0 筆
      And 使用者已登入
  Scenario: 未登入下，有相同 Email 的其他 user 以不同 Open ID 註冊存在時，則會自動綁定，且登入
    Given facebook 登入
          | email | venus@5fpro.com |
          | uid   | 1234            |
      And 使用者登出
     When facebook 登入
          | email | venus@5fpro.com |
          | uid   | 5678            |
     Then User(venus@5fpro.com) 已綁定 facebook 2 筆
      And 使用者已登入
  Scenario: 未登入下，若有相同 email 的其他 user 以一般註冊、尚未驗證存在時，則會自動綁定該 user，設為已驗證，並且登入
    Given User(marsz) 設為未驗證
     When facebook 登入
          | email | marsz@5fpro.com |
     Then User(marsz) 已綁定 facebook 1 筆
      And User(marsz) 狀態為已驗證
      And 使用者已登入
  Scenario: 未登入下，若有相同 email user 已以其他 Open ID 註冊，則會自動綁定該 user，且登入
    Given google 登入
          | email | abc@5fpro.com |
     When facebook 登入
          | email | abc@5fpro.com |
     Then User(abc@5fpro.com) 已綁定 facebook 1 筆
      And User(abc@5fpro.com) 已綁定 google 1 筆
      And 使用者已登入
  Scenario: 未登入下，若有相同 email user 已以相同 Open ID 註冊，則會登入
    Given facebook 登入
          | email | abc@5fpro.com |
      And 使用者登出
     When facebook 登入
          | email | abc@5fpro.com |
     Then User(abc@5fpro.com) 已綁定 facebook 1 筆
      And 使用者已登入
  Scenario: 未登入下，若無相同 email user 註冊時，會建立新帳號，且登入
     When facebook 登入
          | email | abc@5fpro.com |
     Then User(abc@5fpro.com) 已綁定 facebook 1 筆
      And 使用者已登入
  Scenario: 未登入下，若有相同 email 綁定在其他 user 身上，但該 user email 與欲登入的 Open ID 不同時，會建立新帳號，且登入
    Given User(marsz@5fpro.com) 綁定 facebook
          | uid   | 1234 |
     When facebook 登入
          | email | abc@5fpro.com |
          | uid   | 5678          |
     Then User(marsz@5fpro.com) 已綁定 facebook 1 筆
      And User(abc@5fpro.com) 已綁定 facebook 1 筆
      And 使用者已登入
