class VendingMachine

  @@total = 0
  @@sale = 0
  @@juice = []
  @@change = {bill1000:{price:1000,stock:10},
              coin500:{price:500,stock:10},
              coin100:{price:100,stock:10},
              coin50:{price:50,stock:10},
              coin10:{price:10,stock:10}}

  def operation

    puts "合計投入金額:#{@@total}円,購入はp,払い戻しはr"
    drink
    @money = gets.chomp

    if @money == "r"
        refund
    elsif @money == "p"
      purchase
    elsif @money.to_i > 0
      insert
    else
      puts "お金を入れてください"
      operation
    end
# operationメソッドがシンプルでわかやすい
# 条件分岐を上手く使って数字以外を排除しているのもシンプルですごいなと思った

  end

  def insert

    case @money.to_i
      when 10,50,100,500,1000
        sort(@money)
        plus
        @@total += @money.to_i
      else
        puts "利用できない通貨です,釣銭:#{@money}円"
# aaa円と数字＋"文字列"が入るとそれも入ってしまうのをなんとかしたい
    end

    operation

  end

  def refund
    puts "釣銭合計:#{@@total}円"
    puts "1000円札    :#{@bill1000yen}枚"
    puts "500円玉     :#{@coin500yen}枚"
    puts "100円玉     :#{@coin100yen}枚"
    puts "50円玉      :#{@coin50yen}枚"
    puts "10円玉      :#{@coin10yen}枚"
    @@total = 0

    operation

  end

  def drink
    juiceId = 1

    @@juice.each do |i|
      if @@total >= i[:price]
        puts "#{juiceId}:#{i[:name]}:#{i[:price]}円,#{i[:stock]}本"
      end

      juiceId +=1
    end

  end

  def purchase
    puts "購入対象の番号を入力"
    drink
    number = gets.chomp.to_i

    if number <=0 || !@@juice.fetch(number-1,false)
      puts "商品がありません"
    else
      number -=1

      if @@total >= @@juice[number][:price] && @@juice[number][:stock] > 0
        sort(@@total-@@juice[number][:price])
        minus
        if   @@change[:bill1000][:stock] < 0 || @@change[:coin500][:stock] < 0 || @@change[:coin100][:stock]   < 0 || @@change[:coin50][:stock] < 0 || @@change[:coin10][:stock]    < 0
            puts "釣り銭不足"
            plus
        else
          @@juice[number][:stock] -= 1
          @@total -= @@juice[number][:price]
          @@sale += @@juice[number][:price]
          puts "#{@@juice[number][:name]}購入\n売上合計:#{@@sale}円"
          refund
        end
      elsif @@total >= @@juice[number][:price] && @@juice[number][:stock] <= 0
        puts "在庫切れ"
      else
        puts "お金が足りません"
      end

    end

    operation

  end

  def store(newName,newPrice,newStock)
    newJuice = {name:newName,price:newPrice,stock:newStock}
    @@juice << newJuice
  end

  def sort(integer)
    i = integer.to_i
      @bill1000yen = i / @@change[:bill1000][:price]; i -= @bill1000yen * 1000
      @coin500yen  = i / @@change[:coin500][:price]; i -= @coin500yen * 500
      @coin100yen  = i / @@change[:coin100][:price]; i -= @coin100yen * 100
      @coin50yen   = i / @@change[:coin50][:price]; i -= @coin50yen * 50
      @coin10yen   = i / @@change[:coin10][:price]; i -= @coin10yen * 10
  end


  def plus
    @@change[:bill1000][:stock] += @bill1000yen
    @@change[:coin500][:stock] += @coin500yen
    @@change[:coin100][:stock] += @coin100yen
    @@change[:coin50][:stock] += @coin50yen
    @@change[:coin10][:stock] += @coin10yen
  end

  def minus
    @@change[:bill1000][:stock] -= @bill1000yen
    @@change[:coin500][:stock] -= @coin500yen
    @@change[:coin100][:stock] -= @coin100yen
    @@change[:coin50][:stock] -= @coin50yen
    @@change[:coin10][:stock] -= @coin10yen
  end

# プラスとマイナスの計算のためだけに、インスタンスメソッドを2つ用意して同じようなコードを書く必要は無さそう

end


machine1 = VendingMachine.new

machine1.store("コーラ",120,5)
machine1.store("レッドブル",200,5)
machine1.store("水",100,5)
machine1.store("ダイエットコーラ",120,5)
machine1.store("お茶",120,5)

machine1.operation
