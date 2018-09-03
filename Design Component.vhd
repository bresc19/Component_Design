library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity project_reti_logiche is
     port (
      i_clk:      in  std_logic;
      i_start:    in  std_logic;
      i_rst:      in  std_logic;
      i_data:     in  std_logic_vector(7 downto 0);
      o_address:  out std_logic_vector(15 downto 0);
      o_done:     out std_logic;
      o_en:       out std_logic;
      o_we:       out std_logic;
      o_data:     out std_logic_vector (7 downto 0)
      );
end project_reti_logiche;





architecture Behavioral of project_reti_logiche is

    component project_tb
        port(
           tb_clk            :  out std_logic;
           tb_done           :  in std_logic;
           mem_address       :  in std_logic_vector (15 downto 0);
           tb_rst            :  out std_logic;
           tb_start          :  out std_logic;
           mem_o_data        :  out std_logic_vector (7 downto 0);
           mem_i_data        :  in std_logic_vector (7 downto 0);
           enable_wire       :  in std_logic;
           mem_we            :  in std_logic

            );
end component;










    type state_type is (s0,s00,s1,s011,s2,s22,s3,s33,s4,s44,s5,s6,s7,s8,s88,s9,s99,s_done);


             signal x : unsigned(7 downto 0) := "00000000";
             signal y : unsigned(7 downto 0) := "00000000";
             signal columns : unsigned(7 downto 0) := "00000000";
             signal rows : unsigned(7 downto 0) := "00000000";
             signal soglia : unsigned(7 downto 0) := "00000000";







    type step is (s0,s00,s1,s011,s2,s22,s3,s33,s4,s44,s5,s6,s7,s8,s88,s9,s99,s_done);
    signal state : step;


    begin



	   process (i_clk)

	   variable i : unsigned(7 downto 0) := "00000001";
       variable j : unsigned(7 downto 0) := "00000001";
       variable d : unsigned(15 downto 0) := "0000000000000000";
       variable a : unsigned(7 downto 0) := "00000000";
       variable b : unsigned(7 downto 0) := "00000000";
       variable i_primo  : unsigned(7 downto 0) := "00000000";
       variable j_primo  : unsigned(7 downto 0) := "00000000";
       variable found    : std_logic := '0';
       variable i_ultimo : unsigned(7 downto 0) := "00000000";
       variable j_ultimo : unsigned(7 downto 0) := "00000000";


	   begin

		  if i_rst = '1' then
		    o_en      <= '1';  --assegno enable = 1 per far partire la lettura da RAM
			state <= s0;
		  elsif rising_edge(i_clk) then
		  
			 case state is

			        when s0=>

	               if i_start = '1' then
                        
                         o_done    <= '0';
                         o_we      <= '0';
                         o_address <= "0000000000000010";       --indirizzo che successivamente vado a leggere(base)
                         i:="00000001";
                         j:="00000001";
                         i_ultimo:= "00000000";
                         i_primo:= "00000000";
                         j_ultimo:= "00000000";
                         j_primo:= "00000000";
                         found := '0';
                         d:= "0000000000000000";
                         a:="00000000";
                         b:="00000000"; 
                         soglia <= "00000000";
                        x<="00000000";
                        y<= "00000000";
                        columns <= "00000000";
                        rows <= "00000000";
                         state <= s00;

                     else state <= s0;

                     end if;


                    when s00 =>

                        state     <= s1; --stato di buffer



				    when s1=>

				    if i_data = "00000000"then      --caso in cui la base del rettangolo sia ZERO
				        state <= s8;
				    else 
                     columns   <= unsigned(i_data);      --assegno il numero di colonne (base)
                     o_address <= "0000000000000011";        --indirizzo che leggo successivamente (altezza)
                     end if;


                    state     <= s011;


                    when s011=>
                        state     <= s2;            --stato di buffer



				when s2=>
				    if i_data = "00000000"then      --caso in cui l'altezza del rettangolo sia ZERO
                       state <= s8;
                   else 
                    rows  <= unsigned(i_data);          --assegno il numero di righe (altezza)
                    o_address <= "0000000000000100";    --indirizzo che leggo successivamente (soglia)

                    state <= s22;
                    end if;


                when s22 =>
                    state <= s3;                    --stato di buffer


				when s3=>


                    soglia <= unsigned(i_data);                 --acquisizione valore soglia
                    o_address <= "0000000000000101";
                    state <= s33;

               when s33 =>
                   state <= s44;            --stato di buffer

               when s44 =>
                    state <= s4;            --stato di buffer




				when s4=>


                    if unsigned(i_data) >= soglia then          --confronto con ilvalore soglia
                        state <= s5;
                    else
                        state <= s6;                            --vado allo stato in cui incremento l'indici i/j del rettangolo[][]
                    end if;

                when s5=>
                    if found = '0'  then
                        i_primo := i;
                        j_primo := j;
                        found   := '1';
                    end if;                                     --in questo stato vado ad incrementare gli estremi dell'immagine che sto leggendo

                    if j < j_primo then
                        j_primo := j;
                    end if;

                    
                    if j > j_ultimo then
                        j_ultimo := j;
                    end if;

                    if i > i_ultimo then
                        i_ultimo := i;
                    end if;

                    state <= s6;


                when s6=>

                    if (j >= columns and i >= rows) then                --se entra in questo if significa che ho finito di acquisie i dati.
                        state <= s7;


                   elsif (j = columns) then                         --vado alla riga successiva (rettangolo[i+1][1])
                        i := i + 1;
                        d := d + 1;
                        j :=    "00000001";
                        o_address <= std_logic_vector(d) + 5;
                        state <= s44;
                    else
                        j := j + 1;                                     --vado all'elemento successivo del rettangolo[i][j+1]
                        d := d + 1;
                        o_address <= std_logic_vector(d) + 5;
                        state <= s44;
                    end if;




                when s7=>

                    if i_ultimo = "00000000" then                           --se non ho trovato alcun estremo allora l'immagine è nulla
                        x <= "00000000";                                    --e assegno ai vettori x e y il valore ZERO che andranno a scrivere in memoria
                        y <= "00000000";
                        state <= s8;

                    else
                        a  := (unsigned(i_ultimo) - unsigned(i_primo)) + 1;         --calcolo dell'altezza dell'immagine
                        b  := (unsigned(j_ultimo) - unsigned(j_primo)) + 1;         --calcolo della base dell'immagine
                        d  := (unsigned(a)* unsigned(b));                           --calcolo area dell'immagine
                        x <= d(15 downto 8);                                        --metto i bit da 15 a 8 in x
                        y <= d(7 downto 0);                                         --mettoi bit da 7 a 0 in y
                        state <= s8;

                    end if;

                when s8 =>


                    o_data <=std_logic_vector(y);                   --scrivo y nella prima cella di memoria

                    o_we <= '1';
                    o_address <= "0000000000000000";

                    state <= s88;

                when s88=>
                    o_data <=std_logic_vector(y);               --stato di buffer

                    state <= s9;

                when s9 =>


                    o_data <=std_logic_vector(x);       --scrivo x nella seconda celladi memoria e pongo done = 1 perché ho finito la computazione

                    o_address <= "0000000000000001";
                    o_done   <= '1';
                    state <= s99;

                 when s99 =>
                     o_data <=std_logic_vector(x);              --stato di buffer

                    state <= s_done;


                 when s_done =>
                    o_done <= '0'; 
                    o_we <= '0';             --stato finale che si ripete fino quando non termina l'esecuzione del testbench
                    state <= s_done;




			end case;


	   end if;
	end process;


end Behavioral;
