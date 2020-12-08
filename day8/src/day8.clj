(ns day8)

(use
 'clojure.java.io)

(def ops
  (reduce
   #(conj %1 [(nth (nth %2 0) 1), (nth (nth %2 0) 2)])
   []
   (mapv #(re-seq #"([a-z]+) (\-?\+?(\d+))" %)
         (with-open [rdr (reader "input.txt")]
           (doall (line-seq rdr))))))

(defn inc-by
  [current-atom num]
  (+ current-atom num))

(defn run [ops]
  (do
    (def seen (atom #{}))
    (def i (atom 0))
    (def acc (atom 0))

    (while (and (not (contains? @seen @i)) (>= @i 0) (< @i (count ops)))
      (do
        (def opcode (nth (nth ops @i) 0))
        (def oparg (Integer. (nth (nth ops @i) 1)))

        (swap! seen conj @i)

        (case opcode
          "acc" (do (swap! acc inc-by oparg) (swap! i inc))
          "jmp" (swap! i inc-by oparg)
          "nop" (swap! i inc)
          ())))
    ; need this to return the acc value
    (do [(>= @i (count ops)), @acc, @i])))

(def n (atom 0))

(while (< @n (count ops))
  (do
    (def opcode (nth (nth ops @n) 0))
    (def oparg (Integer. (nth (nth ops @n) 1)))
    (cond (or (= opcode "jmp") (= opcode "nop"))
      (do
        (case opcode
          "nop" (def new_opcode "jmp")
          "jmp" (def new_opcode "nop")
          ())
        (def new_ops (assoc ops @n [new_opcode, oparg]))

        (def res (run new_ops))
        (cond (= true (nth res 0)) (def part2 (nth res 1))))
      :else ())
    (swap! n inc)))


(def part1 (nth (run ops) 1))

(println (format "Part 1: %d" part1))
(println (format "Part 2: %d" part2))