class Thor
  module Shell
    class Basic
      # Ask something to the user and receives a response.
      #
      # ==== Example
      # ask("What is your name?")
      #
      def ask(statement, color=nil)
        say("#{statement} ", color)
        $stdin.gets.strip
      end

      # Say (print) something to the user. If the sentence ends with a whitespace
      # or tab character, a new line is not appended (print + flush). Otherwise
      # are passed straight to puts (behavior got from Highline).
      #
      # ==== Example
      # say("I know you knew that.")
      #
      def say(statement="", color=nil)
        statement = statement.to_s

        if statement[-1, 1] == " " || statement[-1, 1] == "\t"
          $stdout.print(statement)
          $stdout.flush
        else
          $stdout.puts(statement)
        end
      end

      # Say a status with the given color and appends the message.
      #
      def say_status(status, message, color=nil)
        status_flag = "[#{status.to_s.upcase}]".rjust(12)
        say "#{status_flag} #{message}"
      end

      # Make a question the to user and returns true if the user replies "y" or
      # "yes".
      #
      def yes?(statement, color=nil)
        ["y", "yes"].include?(ask(statement, color).downcase)
      end

      # Make a question the to user and returns true if the user replies "n" or
      # "no".
      #
      def no?(statement, color=nil)
        !yes?(statement, color)
      end

      # Prints a list of items.
      #
      # ==== Parameters
      # list<Array[String, String, ...]>
      # mode<Symbol>:: Can be :rows or :inline. Defaults to :rows.
      #
      def print_list(list, mode=:rows)
        return if list.empty?

        content = case mode
          when :inline
            last = list.pop
            "#{list.join(", ")}, and #{last}"
          else # rows
            list.join("\n")
        end

        $stdout.puts content
      end

      # Prints a table.
      #
      # ==== Parameters
      # Array[Array[String, String, ...]]
      #
      # ==== Options
      # ident<Integer>:: Ident the first column by ident value.
      # emphasize_last<Boolean>:: When true, add a different behavior to the last column.
      #
      def print_table(table, options={})
        return if table.empty?

        formats = []
        0.upto(table.first.length - 2) do |i|
          maxima = table.max{ |a,b| a[i].size <=> b[i].size }[i].size
          formats << "%-#{maxima + 2}s"
        end

        formats[0] = formats[0].insert(0, " " * options[:ident]) if options[:ident]
        formats << "%s"

        if options[:emphasize_last]
          table.each do |row|
            next if row[-1].empty?
            row[-1] = "# #{row[-1]}"
          end
        end

        table.each do |row|
          row.each_with_index do |column, i|
            $stdout.print formats[i] % column.to_s
          end
          $stdout.puts
        end
      end

      # Called if something goes wrong during the execution. This is used by Thor
      # internally and should not be used inside your scripts. If someone went
      # wrong, you can always raise an exception. If you raise a Thor::Error, it
      # will be rescued and wrapped in the method below.
      #
      def error(statement) #:nodoc:
        $stderr.puts statement
      end
    end
  end
end