import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:specialists_analyzer/app/consts/colors.dart';
import 'package:specialists_analyzer/domain/entities/diagram_estimation.dart';
import 'package:specialists_analyzer/domain/repositories/app_repository_impl.dart';
import 'package:specialists_analyzer/presentation/bloc/auth/auth_cubit.dart';
import 'package:specialists_analyzer/presentation/bloc/specialists_diagrams/specialists_diagrams_cubit.dart';
import 'package:specialists_analyzer/presentation/popups/add_challenge_popup.dart';
import 'package:specialists_analyzer/presentation/popups/add_specialist_popup.dart';
import 'package:specialists_analyzer/presentation/popups/edit_challenge_popup.dart';
import 'package:specialists_analyzer/presentation/popups/edit_specialist_popup.dart';
import 'package:specialists_analyzer/presentation/popups/remove_challenge_popup.dart';
import 'package:specialists_analyzer/presentation/popups/remove_diagram_popup.dart';
import 'package:specialists_analyzer/presentation/popups/remove_specialist_popup.dart';
import 'package:specialists_analyzer/presentation/popups/specialist_estimation_popup.dart';
import 'package:specialists_analyzer/presentation/widgets/table/app_table.dart';
import 'package:specialists_analyzer/presentation/widgets/table/app_table_action.dart';
import 'package:specialists_analyzer/presentation/widgets/table/app_table_column.dart';
import 'package:specialists_analyzer/presentation/widgets/table/app_table_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    final userId = context.read<AuthCubit>().state.user!.uid;
    context.read<SpecialistsDiagramsCubit>().listenChallenges(userId: userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: AppColors.secondary,
                    size: 26,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    user!.email!,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        context.read<AuthCubit>().signOut();
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                        color: AppColors.secondary,
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<SpecialistsDiagramsCubit, SpecialistsDiagramsState>(
                builder: (context, state) => state.challenges == null
                    ? SizedBox.shrink()
                    : state.challenges!.isEmpty
                        ? _noChallenges()
                        : AppTable(
                            header: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                      width: 170,
                                      color: Colors.transparent,
                                      child: DropdownMenu(
                                          initialSelection: state
                                              .selectedChallenge!.id,
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                          requestFocusOnTap: false,
                                          enableSearch: false,
                                          onSelected: (val) {
                                            context
                                                .read<
                                                    SpecialistsDiagramsCubit>()
                                                .listenSpecialists(
                                                    challengeId: val!);
                                          },
                                          inputDecorationTheme:
                                              InputDecorationTheme(
                                                  outlineBorder: BorderSide
                                                      .none,
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                  labelStyle:
                                                      TextStyle(fontSize: 12),
                                                  constraints:
                                                      BoxConstraints.tight(
                                                          const Size.fromHeight(
                                                              30)),
                                                  border: InputBorder.none),
                                          menuStyle: MenuStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.black),
                                          ),
                                          selectedTrailingIcon:
                                              Transform.translate(
                                                  offset: Offset(3, -5),
                                                  child: Icon(
                                                    Icons.arrow_drop_up,
                                                    color: AppColors.secondary,
                                                    size: 18,
                                                  )),
                                          trailingIcon: Transform.translate(
                                              offset: Offset(3, -5),
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                color: AppColors.secondary,
                                                size: 18,
                                              )),
                                          dropdownMenuEntries:
                                              state.challenges!.map((e) {
                                            return DropdownMenuEntry(
                                                value: e.id,
                                                label: e.name,
                                                labelWidget: Text(
                                                  e.name,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                trailingIcon: Row(
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          showEditChallengePopup(
                                                              context,
                                                              challengeId:
                                                                  e.id);
                                                        },
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: AppColors
                                                              .secondary,
                                                          size: 18,
                                                        )),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          showRemoveChallengePopup(
                                                              context, e.id);
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: AppColors
                                                              .secondary,
                                                          size: 18,
                                                        )),
                                                  ],
                                                ));
                                          }).toList())),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      showAddChallengePopup(context);
                                    },
                                    child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Container(
                                            color: Colors.transparent,
                                            child: Icon(
                                              Icons.add,
                                              size: 24,
                                              color: AppColors.accent,
                                            ))),
                                  )
                                ],
                              ),
                            ),
                            columns: [
                              SizedBox(
                                width: 400,
                                child: AppTableColumn(
                                  loading: state.specialists == null,
                                  title: "Спеціалісти",
                                  action: AppTableAction(
                                    text: "Додати спеціаліста",
                                    onTap: () {
                                      showAddSpecialistPopup(context);
                                    },
                                  ),
                                  rows: state.specialists
                                          ?.map((e) => AppTableRow(
                                                text: e.name,
                                                isSelected: e.id ==
                                                    state.selectedSpecialistId,
                                                onTap: () {
                                                  context
                                                      .read<
                                                          SpecialistsDiagramsCubit>()
                                                      .listenDiagrams(
                                                          specialistId: e.id);
                                                },
                                                prefixWidget: e.estimation != null ? Center(child: Text(e.estimation?.average.toStringAsFixed(2) ?? "0.0", style: TextStyle(color: AppColors.secondary),)) : null,
                                                suffixWidgets: [
                                                  if(e.estimation != null)
                                                    Container(
                                                      margin: EdgeInsets.only(right: 12),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showSpecialistEstimationPopup(context, id: e.id);
                                                        },
                                                        child: state
                                                            .analyzingSpecialist
                                                            ? SizedBox(
                                                          width: 18,
                                                          height: 18,
                                                          child: CircularProgressIndicator(
                                                            color: AppColors
                                                                .secondary,
                                                          ),
                                                        )
                                                            : Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: Icon(
                                                              Icons.description,
                                                              color: AppColors
                                                                  .secondary,
                                                              size: 18,
                                                            )),
                                                      ),
                                                    ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              SpecialistsDiagramsCubit>()
                                                          .estimateSpecialist(
                                                              id: e.id);
                                                    },
                                                    child: state
                                                            .analyzingSpecialist
                                                        ? SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child: CircularProgressIndicator(
                                                              color: AppColors
                                                                  .secondary,
                                                            ),
                                                        )
                                                        : Container(
                                                            color: Colors
                                                                .transparent,
                                                            child: Icon(
                                                              Icons.play_arrow,
                                                              color: AppColors
                                                                  .secondary,
                                                            )),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showEditSpecialistPopup(
                                                          context,
                                                          name: e.name,
                                                          id: e.id);
                                                    },
                                                    child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: AppColors
                                                              .secondary,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showRemoveSpecialistPopup(
                                                          context,
                                                          id: e.id);
                                                    },
                                                    child: Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: AppColors
                                                              .secondary,
                                                        )),
                                                  ),
                                                ],
                                              ))
                                          .toList() ??
                                      [],
                                ),
                              ),
                              Expanded(
                                  child: AppTableColumn(
                                title: "Діаграми",
                                loading: state.diagrams == null,
                                showContent: state.selectedSpecialistId != null,
                                action: AppTableAction(
                                  text: "Додати діаграму",
                                  onTap: () async {
                                    final file = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (file == null) return;

                                    final fileName = file.name;
                                    final bytes = await file.readAsBytes();

                                    if (!context.mounted) return;
                                    context
                                        .read<SpecialistsDiagramsCubit>()
                                        .addDiagram(
                                            fileName: fileName, bytes: bytes);
                                  },
                                ),
                                rows: state.diagrams
                                        ?.map((e) => AppTableRow(
                                              text: e.name,
                                              isSelected: e.id ==
                                                  state.selectedDiagramId,
                                              onTap: () {
                                                context
                                                    .read<
                                                        SpecialistsDiagramsCubit>()
                                                    .selectDiagram(
                                                        diagramId: e.id);
                                              },
                                              suffixWidgets: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showRemoveDiagramPopup(
                                                        context,
                                                        id: e.id);
                                                  },
                                                  child: Container(
                                                      color: Colors.transparent,
                                                      child: Icon(
                                                        Icons.delete,
                                                        color:
                                                            AppColors.secondary,
                                                      )),
                                                ),
                                              ],
                                            ))
                                        .toList() ??
                                    [],
                              )),
                              if (state.selectedDiagramId != null)
                                SizedBox(
                                  width: 500,
                                  child: AppTableColumn(
                                      title: "Деталі",
                                      loading: state.diagrams == null,
                                      showContent:
                                          state.selectedSpecialistId != null,
                                      rows: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        if (state.analyzingDiagram)
                                          Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        else if (state
                                                .selectedDiagram?.estimation ==
                                            null)
                                          _noData()
                                        else
                                          _estimationData(state
                                              .selectedDiagram!.estimation!),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Container(
                                          height: 2,
                                          width: double.infinity,
                                          color: AppColors.border,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        if (state.selectedDiagram?.estimation
                                                ?.diagram !=
                                            null)
                                          Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 15),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: AppColors
                                                              .border))),
                                              child: Text(
                                                state.selectedDiagram!
                                                    .estimation!.diagram!,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Image.network(
                                            state.selectedDiagram!.imgUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ]),
                                )
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _estimationData(DiagramEstimation estimation) {
    return Column(
      children: [
        Center(
          child: Icon(
            Icons.area_chart,
            color: AppColors.secondary,
            size: 40,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "Віповідність бізнес-вимогам: ${estimation.businessRequirements}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.secondary),
        ),
        Text(
          "Структурованість: ${estimation.structure}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.secondary),
        ),
        Text(
          "Зрозумілість: ${estimation.clear}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.secondary),
        ),
        Text(
          "Розширюваність: ${estimation.extension}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.secondary),
        ),
        SizedBox(
          height: 12,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            onPressed: () {
              context
                  .read<SpecialistsDiagramsCubit>()
                  .estimateSelectedDiagram();
            },
            child: Text(
              "Повторно проаналізувати",
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  Widget _noData() {
    return Column(
      children: [
        Center(
          child: Icon(
            Icons.area_chart,
            color: AppColors.secondary,
            size: 40,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Center(
          child: Text(
            "Дана діаграма ще не була оцінена штунчим інтелектом",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.secondary),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
            ),
            onPressed: () {
              context
                  .read<SpecialistsDiagramsCubit>()
                  .estimateSelectedDiagram();
            },
            child: Text(
              "Почати аналіз",
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  Widget _noChallenges() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 4)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Cтворіть своє перше випробування!",
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                showAddChallengePopup(context);
              },
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                      color: Colors.transparent,
                      child: Icon(
                        Icons.add,
                        size: 24,
                        color: AppColors.accent,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}
