��h%�hQ����������h~��APIProbe     DOS API Compatibility Tester
$v 1.0        Copyright 2019 by Mercury0x0D
$Testing complete.
$
$Function testing failed
$Function testing passed
$                                                                        U��f�vf�~f�Nf�    f�� t
�uf�   ��]� U��f�vf�~f�Nf��f�� t"fg�f��fg�f��fg�f��fg�f����f�Nf��f�� t�g�fG����]� U��f�vf�Nf�^f��f�f9�tg�fF���]� U��	�V�!��]� U��	���!��]�U��	���!�	���!��]�U��`�`X����SP�� X����SP�� X����%SP�� X����SP�� X�g��SP�� X�g��%SP� X�g��SP� X�g��SP� �g�	�!���	�!�a��]� AX 0000    BX 0000    CX 0000    DX 0000 $ SI 0000    DI 0000    SP 0000    BP 0000 $U��v�~�� !�������Ί�G�v� !����Ί���]� U��v�~� �!�������Ί�G�v� !�������Ί�G�v�� !�������Ί�G�v� !����Ί�G��]� U��F�v`j0j V�/�a��� �  ���0�N�� t���]� U��F�v`j0j
V���a��	�
 �  ���0�N�� t���]� U��v�~� �!��������G� !��������G�� !��������G� !�����G��]� U��F�v`j0jV�}�a��
� �  ���0�N�� t���]� U����v���F��~� <�~� t6�F�  �F� �N��v�N�  �<0r<1w�0(؋^��  ��F��f�����F�  �F���]� U����v�a�F��~�
F�~� t@�F�  �F� �N��v�N�  �<0r)<9w%�0(؋^��  ��F��F��f�F�F�����F�  �F���]� U����v���F��~�U�~� tO�F�  �F� �N��v�N�  �<0r<9w�0�<Ar<Fw�7�
<ar <fw�W(؋^��  ��F��f�����F�  �F���]� U����v��F��~�=�~� t7�F�  �F� �N��v�N�  �<0r <8w�0(؋^��  ��F��f�����F�  �F���]� U��^�< t<Ar<Zw �C���]� U��^�< t<ar<zw, �C���]� U���v�� ��~�F�� ���]� U��^�V�< tӉ�JS��ӈ[< tBC����]� U���v� ���vΉ�G�N�A��������F���]� U��^�V�< t�C����]� U����v�W �F��^;^�v�D�v�D �F��^�V�N��ʋF�É�~���9�tOK��^ˋVS�ӊ[< t�BC����]� U��~������ �)�O����]� U����v����F��F�^�9�s$+F�P�vv���ǋN�A�������X�vP�v�;���]� U����v���F��F�^�9�s+F��^^�S�vPS�
�[^� ��]� U��^�N�V�< t	8�u�C���]� U��^�F�N�V
��8�|��< t8�r8�w�C���]� U����v������ t�N��~�F�u)N��F���]� U����F����v����� t7�F��v����� t)�F��N��v��ˋN��~�u+~�F�9�s�~���F���~��u�F�  �F���]� U���%�v���� tvj^�v�Z��F��~� te���%�F�j j!�v�����v��v���~ uj0�v��9�^��< u
�^��0C� ��~ s	�v�v��t�v��v�F��N��v��v��v����]� U����v����� tvj^�v����F��~� te����F�j j�v��^��v��v�E��~ uj0�v���^��< u
�^��0C� ��~
s	�v�v����v��v���N��v��v��v����]� U����v�g��� twj^�v�@��F��~� tf����F�j j	�v�����v��v����~ ufj0�v���^��< u
�^��0C� ��~s	�v�v��Y�v��v�+��N��v��v��v����]� U����v����� tvj^�v���F��~� te����F�j j�v��C��v��v���~ uj0�v�� �^��< u
�^��0C� ��~s	�v�v��� �v��v���N��v��v��v�����]� U����v�L��� t8j^�v�%��F��~� t'�~ t	�v�v�} �v��v�O��N��v��v�v����]� U��^�N�ڊ8�u< tC��9�tS��ӈ[< tBC����]� U��^�NS����^�K�N�< t8�uK��C� ��]� U����v���F��F�^�9�s�v�)�@P�vV����]� U����v�o��F��F�^�9�s	�~Ǹ  ���]� U���	�  �v�D��� tX�F��v�6��� tJ�F��N��F� �F�  �F�  �v�VQ�v�F����P��Y^�� t�F���^���t�F��F��ЋF���]� U���	�  �v����� t{�F��v����� tm�F��N��F� �F�  �F�  �v�~
� ��VPQ�v�F����P����YX^�� t�F�^�9�t&�~
� ��F���^���t�F��F�`P�v
�n�aⳋF���]� �  �ػ����U���N���]� U��h1������jA���� �!<At���h����h����+jB���� �!<Bt��h���h������h����j��]�Testing interrupt 0x21 AX = 0x0100 - Read char from STDIN with echo
$A key was returned when there should have been none.
$The key returned was not the one provided.
$U����F� �F� h�������� �A�!<At�F�  ��� �	�!< t�F�  ��� �B�!<Bt�F�  ��h��hd��h��{�~�u0h��o����������
���.�>�N���h��?�������~�u,h=�(��������������������h�����m�������]�Testing interrupt 0x21 AX = 0x0200 - Write character to STDOUT
$Although this function returns nothing officially, multiple DOS implementations
$(at least MS-DOS 2.10 through 7.00) have been observed to contain the ASCII
$code in AL of the character printed, or ASCII code 32 for tabs.
$This DOS successfully exhibited this behaviour for regular characters.
$This DOS successfully exhibited this behaviour for tab characters.
$This DOS failed to exhibit this behaviour for regular characters.
$This DOS failed to exhibit this behaviour for tab characters.
$U��h5�� `�!`�)<uh����h���he����]�Testing interrupt 0x21 AX = 0x1800 - Reserved
$This function should return immediately, but one or more registers were changed.
$U��h���� `�!`�w<uh�����h����h����]�Testing interrupt 0x21 AX = 0x1D00 - Reserved
$This function should return immediately, but one or more registers were changed.
$U��h��G� `�!`��<uh��3��h��+�h��%��]�Testing interrupt 0x21 AX = 0x1E00 - Reserved
$This function should return immediately, but one or more registers were changed.
$U��hK��  `�!`�<uh����h��y�h{�s��]�Testing interrupt 0x21 AX = 0x2000 - Reserved
$This function should return immediately, but one or more registers were changed.
$U��h����� a`�!`�a<uh�����h����h=����]�Testing interrupt 0x21 AX = 0x6100 - Reserved for network use
$This function should return immediately, but one or more registers were changed.
$U��h��!�� k`�!`� <uh����h���h�����]�Testing interrupt 0x21 AX = 0x6B00 - Reserved
$This function should return immediately, but one or more registers were changed.
$U��F�^9�u@�F�^9�u6�F�^9�u,�F�^9�u"�F�^9�u�F�^ 9�u�F�^"9�u��� ��]�  U���������������������������������������������������������������	�����]�U��������������]�U����������������]�U����������������������]�U����������]�U����������]�U���������]�U����	��]� 0123456789ABCDEF