
class CardScanner
  def luhn(str)
    luhn = 0
    doubleit = false
    str.each_char { |c|
      val = c.to_i
      if doubleit
        val = val * 2
      end
      val.to_s.scan(/./).each { |d| luhn += d.to_i }
      doubleit = !doubleit
    }
    return luhn
  end

  def process()
    while line = $stdin.readline($/)
      line = line.reverse
      [16, 15, 14].each { |count|
        original = ''
        potential = ''
        idx = -1
        line.each_char { |current|
          idx += 1
          original += current
          if ((current == ' ') or (current == '-'))
            if (potential.length >= count)
              original = original.slice(1, original.length)
            end
            next
          end
          if ((current < '0') or (current > '9'))
            original = ''
            potential = ''
            next
          end
          potential += current
          if (potential.length < count)
            next
          end
          if (potential.length > count)
            potential = potential.slice(1, potential.length)
            original = original.slice(1, original.length)
          end
          if potential.length < count
            continue
          end
    
          if (luhn(potential) % 10) == 0
            masked = original.gsub(/[0-9]/, 'X')
            result = ''
            if ((idx - masked.length + 1) > 0)
              result = line.slice(0, (idx - masked.length + 1))
            end
            result += masked
            if ((idx + 1) < line.length)
              result += line.slice((idx + 1), line.length)
            end
            line = result
          end
        }
      }
      $stdout.puts line.reverse
      $stdout.flush()
      if ($stdin.eof? == true)
        break
      end
    end
  end
end

CardScanner.new().process()
